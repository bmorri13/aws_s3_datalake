variable "env" {
    type = string
}

variable "data_source" {
    type = string
}

variable "data_tier" {
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

variable "glue_db_name" {
  type        = string
}

variable "glue_etl_role_arn" {
    type = string
}

variable "schedule" {
    type = string
    default = null
}

variable "number_of_workers" {
    type = number
    default = 5
}

variable "data_age_out_expiration_verified" {
    type    = number
    default = 365
}

variable "data_lifecycle_standard_ia_verified" {
    type    = number
    default = 90
}

variable "data_lifecycle_glacier_verified" {
    type    = number
    default = 180
}

variable "silver_file_path" {
    type = string
}

variable "silver_file_name" {
    type = string
}

variable "glue_db_iam_allowed_arns" {
  type = list(string)
}
