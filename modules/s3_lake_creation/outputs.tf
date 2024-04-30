output "s3_bucket_name" {
  value = aws_s3_bucket.data_lake.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.data_lake.arn
}

output "s3_bucket_name_glue_etl" {
  value = aws_s3_bucket.glue_etl_jobs.bucket
}

output "s3_bucket_arn_glue_etl" {
  value = aws_s3_bucket.glue_etl_jobs.arn
}
