output "glue_database_role_arn" {
  value = aws_iam_role.glue_crawler_role.arn
}

output "glue_etl_role_arn" {
  value = aws_iam_role.glue_job_role.arn
}
