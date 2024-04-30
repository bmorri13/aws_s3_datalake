## Create sandbox datalake
module "datalake_creation" {
    source                  = "../modules/s3_lake_creation"

    env                     = var.env
    s3_bucket_name          = var.s3_bucket_name
}
