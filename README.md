# AWS S3 Data Lake Terraform Deployment

## Overview
Terraform code to deploy out a data lake into AWS to replicate the Medaillion Arhitecture (ie.) Bronze, Silver and, Gold) tiering architeture.

## Prerequisites
- AWS credentials for IAM role creation
- Terraform deployment pipelines within a CI/CD pipeline or Terraform installed locally

## Initial Setup
### Configuring Data Lake Module
- In the root level `main.tf`, make a new module with the name of your desired data lake (ie.) sandbox).
- In the root level `variables.tf` file, add a custom name for you Athena query buckets under the `athena_results_bucket_name` variable.
- Add in the name of your data lake environment, your desired datalake name and, any roles in which you wish to have access to the AWS Glue data tables
- Also, create a directory at the root level to match the environment of your data like (ie.) sandbox_data_lake). This is important because this will house the initial resource calls to deploy out the underlying data lake reosurce for your specificed envirnment and house the data source logic which will be covered in a later sub section.
    - **NOTE:** you must include the same `.tf` files found in the `sandbox_data_lake` folder that you see in this repository in order to build our your data lake successuly. You can remove any data sources under the `sandbox_data_lake/data_sources` folder if you wish to not deploy any resources.

#### Example Module Block

    ## Create sandbox datalake
    module "cointhieves_datalake_sandbox" {
        source                  = "./sandbox_data_lake"

        env                     = "sandbox"
        s3_bucket_name          = "cointhieves-datalake"
        athena_role             = var.athena_role
        glue_db_access        = [ var.athena_role, "arn:aws:iam::278862850009:user/grafana-test-user" ]
    }

- Update the root level `variables.tf` with any desired roles you wish to pass as variables and an initial role to be used to allow Athena and Lake Formation access across all necessary resources.

#### Example Variables

    variable "athena_role" {
        type    = string
        default = "arn:aws:iam::278862850009:user/lake-formation-admin-user"
    }

    variable "gitlab_ci_role" {
        type    = string
        default = "arn:aws:iam::278862850009:user/gitlab_ci_user"
    }

### Configure Data Lake directory settings
- Within your data lake directory, `sandbox_data_lake` in this repository, in the `variables.tf` file update any of the data lifecyle polcy settings as required. The defaults set for those are below:
    - Bronze / Silver / Gold Tier
        - Standard IA Data Tier: 90 days
        - Glacier Data Tier: 180 days
        - Expiration: 365 days
- For additiong data sources, go to the `Adding Data Source` section of this README.md below

### Adding Data Sources
- In order to add a new data source, within your data lake directory, open up the `data_source.tf` file and add a new module block for your data source and create a new directory for your data source with the name you wish to call that data source (ie. **vector_test**).
    - In the module block you added into `data_source.tf` verify you have named the module to include your data source (ie. **datalake_creation_nested_vector_test**)
    - Update the source path with the new data source directory path you created
    - Updated the `data_source_name` variables with the name of your data source

#### Example Module Block

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


### Configuring Data Sources
- Within the data source directory you created (ie.) **vector_test**) this will be where you will configure your Glue Crawlers and Glue ETL Job resource requirements
- To start your data onboarding, creating the below files:
    - `bronze.tf` 
        - Add in your Glue Crawler module and any necessary ETL code required to process raw data to a partitoned / glue table parsable format
            - **NOTE:** - if you need to configure / parse your data from the `raw` directory and do not want to use a Glue Job, you can use S3 ObjectCreate events and trigger processing by Lambda fucntions (not covered in this repository as now).
        - Once the Glue Crawler is ran over your data in the `partioned` directory path, you will be able to query your data in Athena
    - `silver.tf`
        - Add in your Glue Crawler module and any necessary ETL code required to process your data from the bronze tier to the silver tier.
            - Normally, you will use this to further strucure your data from its more 'raw' formatted into a more curated format to make it more performat for querying (ie.) Moving the data to a parquet format, removing duplicate fields, flattentings JSON, etc.)
        - Once the Glue Crawler is ran over your data in the `partioned` directory path, you will be able to query your data in Athena
    - `gold.tf`
        - Add in your Glue Crawler module and any necessary ETL code required to process your data from the silver tier to the gold tier.
            - Normally, this will be used to join data sources for business reporting requirements or for end state parsing logic such as pasring data into and OCSF structured data format
        - Once the Glue Crawler is ran over your data in the `partioned` directory path, you will be able to query your data in Athena
    - `locals.tf` - this file contains the mapping needed for your Glue Job python code
        - The below example includes an example for your silver layer, if you have bronze or gold ETL code, you will have to create new variables for your desired tier and update the pathing accordingly in your tiered `.tf` Glue Job module block
        ```
        locals {
            silver_glue_src_path = "${path.root}/${var.env}_data_lake/data_sources/${var.data_source_name}/code/"
            silver_file_name = "silver_etl_job.py"
        }
        ```
    - `variables.tf` - this file houses all of the required and optional vairables for your data sources
        - **Required**: `data_source_name` - enter in the name of your data source
            - For the optional variables, please see the `Optional Variables` section below

#### Sample Data Source Module Blocks
##### Crawler
```
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
```
##### Glue Job
```
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
}
```

#### Optional Variables
- `Glue Crawlers`
    - **bronze_crawler_schedule** - set a cron schdulede to have the crawler run to pick up any new partition or metadata table changes
    - **silver_crawler_schedule** - set a cron schdulede to have the crawler run to pick up any new partition or metadata table changes
    - **gold_crawler_schedule** - set a cron schdulede to have the crawler run to pick up any new partition or metadata table changes
        - Example Cron: `"cron(*/5 * * * ? *)"` - Run every 5 minutes

- `Glue ETL Jobs`
    - **bronze_etl_job_schedule** - set a cron schdulede to have the Glue Job run to pick up any new partition or metadata table changes
    - **silver_etl_job_schedule** - set a cron schdulede to have the Glue Job run to pick up any new partition or metadata table changes
    - **gold_etl_job_schedule** - set a cron schdulede to have the Glue Job run to pick up any new partition or metadata table changes
        - Example Cron: `"cron(*/5 * * * ? *)"` - Run every 5 minutes
    - **number_of_workers** - set a desired number of workers to process your Glue Jobs

## Terraform Modules
### athena
Deploys out an Athena workergroup and the necessary additional resources to house Athena query results
#### Important Resources
- `aws_athena_workgroup.athena_result_configs` - Creates a new Athena workgroup to house your Athena query results to a created S3 bucket

### glue_crawler
Deploys out the necessary Glue Crawler resources in order to scan and build out Glue Tables with the necesary metadata to be used in upstream data analytics and ETL processing. Also adds any additional roles to be added in via Lake Formation to access the Glue Tables.
#### Important Resources
- `aws_lakeformation_permissions.glue_database_permissions_table` - Adds user permissions to access the underlying Glue Tables
- `aws_s3_object.data_source_partitioned_directory` - Creates the initial object directory path a data source that that is formatted in a partitioned format
- `aws_s3_object.data_source_raw_directory` - Creates the initial object directory path a data source that is iether in a unstructred format or cannot be initially ingested in a partitioned format
- `aws_glue_crawler.glue_crawler` - Creates the necessary Glue Crawler resource to scan and build out the necessary Glue metadata tables for querying and ETL processing

### glue_database
Deployes out the tiered database that is used to host data source tables (ie.) Deploys out a bronze, silver and, gold layer database)
#### Important Resources
- `aws_glue_catalog_database.glue_database` - Creates a databse for the provided data tier (ie.) bronze, silver and, gold layers)

### glue_job
Deployes out the Glue Job resource (including spark python code) used for ETL processing at any data tier.
#### Important Resources
- `aws_s3_object.deploy_script_s3` - Uploads the provided Spark python code that is used called from the Glue Job to conduct ETL processing between tiers
- `aws_glue_job.etl_job` - Creates the Glue Job resource to conduct the ETL processing between tiers
- `aws_s3_object.data_source_partitioned_directory` - Creates the initial object directory path a data source that that is formatted in a partitioned format
- `aws_glue_trigger.schedule_etl_job` - If variables are provided, the Glue Job will run on a scheduled basis

### iam
Deployes out roles required for data processing within the deployment
#### Important Resources
- `aws_iam_role.glue_crawler_role` - Creates a Glue Crawler role to be used by all crawler resources
- `aws_iam_role.glue_job_role` - Creates a Glue Job role to be used by all Glue ETL Job resources

### s3_lake_creation
Deploys out the resources required to configure AWS Lake Formation and downstream management of the underlying components
#### Important Resources
- `aws_iam_role.lake_formation_service_role` - Creates an IAM role to be used to register an S3 bucket to AWS Lake Formation
- `aws_lakeformation_resource.data_lake_s3` - Attaches your S3 data lake bucket to AWS Lake Formation
- `aws_s3_bucket.data_lake` - Creates your data lake bucket
- `aws_s3_bucket.glue_etl_jobs` - Creates a bucket to house all Glue Job ETL python code
- `aws_s3_object.create_bronze_dir` - Create the initial object path for the bronze data tier
- `aws_s3_object.create_silver_dir` - Create the initial object path for the silver data tier
- `aws_s3_object.create_gold_dir` - Create the initial object path for the gold data tier
- `aws_s3_bucket_lifecycle_configuration.data_lifecyle_policy` - Attaches the default data lifecycles policy for your S3 data lake bucket


## Additional Information
### Sending Sample Data
- To send sample data, you can use the Vector example to send JSON data to a Splunk HTTP Event Collector endpoint and have it send to S3 in a date and time partitioned format: [Vector Splunk HEC to S3 Example](https://github.com/bmorri13/vector_hec_to_s3_docker)

### Assorted Links
 - [Databricks Medallion Architecture Overview](https://www.databricks.com/glossary/medallion-architecture)
