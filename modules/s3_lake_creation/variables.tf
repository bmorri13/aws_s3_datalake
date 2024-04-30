variable "env" {
    type = string
}

variable "s3_bucket_name" {
    type = string
}

variable "data_age_out_expiration_bronze" {
    type    = number
    default = 365
}

variable "data_lifecycle_standard_ia_bronze" {
    type    = number
    default = 90
}

variable "data_lifecycle_glacier_bronze" {
    type    = number
    default = 180
}

variable "data_age_out_expiration_silver" {
    type    = number
    default = 365
}

variable "data_lifecycle_standard_ia_silver" {
    type    = number
    default = 90
}

variable "data_lifecycle_glacier_silver" {
    type    = number
    default = 180
}

variable "data_age_out_expiration_gold" {
    type    = number
    default = 365
}

variable "data_lifecycle_standard_ia_gold" {
    type    = number
    default = 90
}

variable "data_lifecycle_glacier_gold" {
    type    = number
    default = 180
}
