## Create sandbox datalake
module "iam_roles" {
    source                  = "../modules/iam"

    env                       = var.env
    s3_bucket_arn             = module.datalake_creation.s3_bucket_arn
    s3_bucket_arn_glue_etl    = module.datalake_creation.s3_bucket_arn_glue_etl
}
