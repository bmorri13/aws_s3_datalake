resource "aws_athena_workgroup" "athena_result_configs" {
  name = "athena-result-configurations"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket_name.bucket}/athena_output/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}