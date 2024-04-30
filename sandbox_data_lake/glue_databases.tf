module "glue_database_creation_bronze" {
  source                  = "../modules/glue_database"

  env                     = var.env
  data_tier               = "bronze"
  s3_bucket_name          = module.datalake_creation.s3_bucket_name
  s3_bucket_arn           = module.datalake_creation.s3_bucket_arn
  athena_role             = var.athena_role
}

module "glue_database_creation_silver" {
  source                  = "../modules/glue_database"

  env                     = var.env
  data_tier               = "silver"
  s3_bucket_name          = module.datalake_creation.s3_bucket_name
  s3_bucket_arn           = module.datalake_creation.s3_bucket_arn
  athena_role             = var.athena_role
}

module "glue_database_creation_gold" {
  source                  = "../modules/glue_database"

  env                     = var.env
  data_tier               = "gold"
  s3_bucket_name          = module.datalake_creation.s3_bucket_name
  s3_bucket_arn           = module.datalake_creation.s3_bucket_arn
  athena_role             = var.athena_role
}
