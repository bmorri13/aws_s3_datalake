## Create Athena Workgroup to store query results
module "athena_results_configurations" {
    source                  = "./modules/athena"

    athena_bucket_name      = var.athena_results_bucket_name
}

## Permission to add data lake read and write permissions (ie. Administrative roles and tasks tab - data lake administrators) 
resource "aws_lakeformation_data_lake_settings" "adding_user" {
  admins = [ var.athena_role, var.gitlab_ci_role ]
}

## Create sandbox datalake
module "cointhieves_datalake_sandbox" {
    source                  = "./sandbox_data_lake"

    env                     = "sandbox"
    s3_bucket_name          = "cointhieves-datalake"
    athena_role             = var.athena_role
    glue_db_access        = [ var.athena_role, "arn:aws:iam::278862850009:user/grafana-test-user" ]
}
