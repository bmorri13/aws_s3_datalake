module "bronze_crawler" {
    source                      = "../../../modules/glue_crawler"
    
    data_tier                   = var.bronze_data_tier
    data_source                 = var.data_source_name
    glue_db_iam_allowed_arns    = concat([var.glue_db_role_arn, var.glue_etl_role_arn], var.glue_db_access)
    glue_db_name                = var.glue_db_names[var.bronze_data_tier]
    glue_db_role_arn            = var.glue_db_role_arn
    env                         = var.env
    s3_bucket_name              = var.s3_bucket_name
    s3_bucket_arn               = var.s3_bucket_arn
}
