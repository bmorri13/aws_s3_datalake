variable "remote_workspace" {
    type = string
    default = "prod"
}

variable "athena_results_bucket_name" {
    type    = string
    default = "cointhieves-athena-results-bucket"
}

variable "athena_role" {
    type    = string
    default = "arn:aws:iam::278862850009:user/lake-formation-admin-user"
}

variable "gitlab_ci_role" {
    type    = string
    default = "arn:aws:iam::278862850009:user/gitlab_ci_user"
}