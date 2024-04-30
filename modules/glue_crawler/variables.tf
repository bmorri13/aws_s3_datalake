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

variable "crawler_exclude_blobs" {
    type    = list(string)
    default = ["raw"]
}

variable "schedule" {
    type = string
    default = null
}

variable "glue_db_name" {
  type        = string
}

variable "glue_db_role_arn" {
  type        = string
}

variable "glue_db_iam_allowed_arns" {
  type = list(string)
}
