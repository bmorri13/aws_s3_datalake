## Sandbox Data Source Module
module "datalake_creation_nested_vector_test" {
    source                    = "./data_sources/vector_test"

    data_source_name          = "vector_test"
    env                       = var.env
    s3_bucket_name            = module.datalake_creation.s3_bucket_name
    s3_bucket_arn             = module.datalake_creation.s3_bucket_arn
    s3_bucket_name_glue_etl   = module.datalake_creation.s3_bucket_name_glue_etl
    s3_bucket_arn_glue_etl    = module.datalake_creation.s3_bucket_arn_glue_etl
    glue_db_names             = local.glue_database_names
    glue_db_role_arn          = module.iam_roles.glue_database_role_arn
    glue_etl_role_arn         = module.iam_roles.glue_etl_role_arn
    glue_db_access            = var.glue_db_access
}

module "datalake_creation_csv_tester_1" {
    source                    = "./data_sources/csv_tester_1"

    env                       = var.env
    s3_bucket_name            = module.datalake_creation.s3_bucket_name
    s3_bucket_arn             = module.datalake_creation.s3_bucket_arn
    s3_bucket_name_glue_etl   = module.datalake_creation.s3_bucket_name_glue_etl
    s3_bucket_arn_glue_etl    = module.datalake_creation.s3_bucket_arn_glue_etl
    glue_db_names             = local.glue_database_names
    glue_db_role_arn          = module.iam_roles.glue_database_role_arn
    glue_etl_role_arn         = module.iam_roles.glue_etl_role_arn
    glue_db_access            = var.glue_db_access
}

module "datalake_creation_json_tester_1" {
    source                    = "./data_sources/json_tester_1"

    env                       = var.env
    s3_bucket_name            = module.datalake_creation.s3_bucket_name
    s3_bucket_arn             = module.datalake_creation.s3_bucket_arn
    s3_bucket_name_glue_etl   = module.datalake_creation.s3_bucket_name_glue_etl
    s3_bucket_arn_glue_etl    = module.datalake_creation.s3_bucket_arn_glue_etl
    glue_db_names             = local.glue_database_names
    glue_db_role_arn          = module.iam_roles.glue_database_role_arn
    glue_etl_role_arn         = module.iam_roles.glue_etl_role_arn
    glue_db_access            = var.glue_db_access
}
