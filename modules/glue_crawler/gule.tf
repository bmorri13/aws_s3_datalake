## Create Glue Crawler to set metadata
resource "aws_glue_crawler" "glue_crawler" {
  name         = "${var.data_tier}-crawler-${var.env}-${var.data_source}"
  role         = var.glue_db_role_arn
  database_name = var.glue_db_name
  description  = "Crawler for ${var.data_tier}-${var.env}-${var.data_source} data"

  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.data_tier}/${var.data_source}"
    exclusions = local.s3_exclude_paths
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  schedule = var.schedule != null ? var.schedule : null
}
