####
##  Silver Layer
####

## Silver Crawler
module "silver_crawler" {
    source                      = "../../../modules/glue_crawler"
    
    data_tier                   = var.silver_data_tier
    data_source                 = var.data_source_name
    glue_db_iam_allowed_arns    = concat([var.glue_db_role_arn, var.glue_etl_role_arn], var.glue_db_access)
    glue_db_name                = var.glue_db_names[var.silver_data_tier]
    glue_db_role_arn            = var.glue_db_role_arn
    env                         = var.env
    s3_bucket_name              = var.s3_bucket_name
    s3_bucket_arn               = var.s3_bucket_arn
    schedule                    = var.silver_crawler_schedule
}

## Silver ETL job
module "silver_etl_job" {
    source                      = "../../../modules/glue_job"
    
    data_tier                   = var.silver_data_tier
    data_source                 = var.data_source_name
    silver_file_path            = local.silver_glue_src_path
    silver_file_name            = local.silver_file_name
    number_of_workers           = 10
    glue_db_iam_allowed_arns    = concat([var.glue_db_role_arn, var.glue_etl_role_arn], var.glue_db_access)
    glue_db_name                = var.glue_db_names[var.silver_data_tier]
    env                         = var.env
    s3_bucket_name              = var.s3_bucket_name
    s3_bucket_name_glue_etl     = var.s3_bucket_name_glue_etl
    s3_bucket_arn               = var.s3_bucket_arn
    glue_etl_role_arn           = var.glue_etl_role_arn
    schedule                    = var.silver_etl_job_schedule
}
