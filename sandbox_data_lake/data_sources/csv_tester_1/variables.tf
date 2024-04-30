variable "env" {
    type = string
}

variable "s3_bucket_name" {
    type = string
}

variable "s3_bucket_arn" {
    type = string
}

variable "s3_bucket_name_glue_etl" {
    type = string
}

variable "s3_bucket_arn_glue_etl" {
    type = string
}

variable "glue_db_access" {
    type = list(string)
}

variable "glue_db_names" {
  type = map(string)
}

variable "glue_db_role_arn" {
  type = string
}

variable "glue_etl_role_arn" {
    type = string
}

variable "bronze_data_tier" {
    type = string
    default = "bronze"
}

variable "silver_data_tier" {
    type = string
    default = "silver"
}

variable "gold_data_tier" {
    type = string
    default = "gold"
}

variable "bronze_crawler_schedule" {
    type = string
    default = null
}

variable "bronze_etl_job_schedule" {
    type = string
    default = null
}

variable "silver_crawler_schedule" {
    type = string
    default = null
}

variable "silver_etl_job_schedule" {
    type = string
    default = null
}

variable "gold_crawler_schedule" {
    type = string
    default = null
}

variable "gold_etl_job_schedule" {
    type = string
    default = null
}

variable "data_source_name" {
    type = string
    default = "csv_tester_1"
}
