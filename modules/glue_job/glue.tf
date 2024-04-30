resource "aws_s3_object" "deploy_script_s3" {
  bucket = var.s3_bucket_name_glue_etl
  key = "/${var.data_tier}/${var.data_source}/scripts/${var.silver_file_name}"
  source = "${var.silver_file_path}${var.silver_file_name}"
  etag = filemd5("${var.silver_file_path}${var.silver_file_name}")
}

resource "aws_glue_job" "etl_job" {
  glue_version = "4.0"
  name = "${var.env}-${var.data_tier}-${var.data_source}-etl-job"
  description = "Deployment of an aws glue etl job"
  role_arn = var.glue_etl_role_arn
  number_of_workers = var.number_of_workers
  worker_type = "G.1X" #optional
  timeout = "60" #optional
  execution_class = "FLEX" #optional
  tags = {
    env = var.env
  }
  command {
    name="glueetl"
    script_location = "s3://${var.s3_bucket_name_glue_etl}/${var.data_tier}/${var.data_source}/scripts/${var.silver_file_name}"
  }
  default_arguments = {
    "--class"                   = "GlueApp"
    "--enable-job-insights"     = "true"
    "--enable-auto-scaling"     = "false"
    "--enable-glue-datacatalog" = "true"
    "--job-language"            = "python"
    "--job-bookmark-option"     = "job-bookmark-enable"
    "--conf"                    = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"

  }
}

resource "aws_glue_trigger" "schedule_etl_job" {
  count    = var.schedule != null && var.schedule != "" ? 1 : 0

  name     = "${var.env}-${var.data_tier}-${var.data_source}-etl-job-trigger"
  type     = "SCHEDULED"
  schedule = var.schedule

  actions {
    job_name = aws_glue_job.etl_job.name
  }
}
