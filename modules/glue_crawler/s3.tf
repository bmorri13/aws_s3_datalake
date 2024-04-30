## Initlize data source raw directory
resource "aws_s3_object" "data_source_raw_directory" {
  count         = var.data_tier == "bronze" ? 1 : 0

  bucket        = var.s3_bucket_name
  key           = "${var.data_tier}/${var.data_source}/raw/"
  content_type  = "application/x-directory"
  source        = "/dev/null"
}

## Initlize data source partitioned directory
resource "aws_s3_object" "data_source_partitioned_directory" {
  bucket        = var.s3_bucket_name
  key           = "${var.data_tier}/${var.data_source}/partitioned/"
  content_type  = "application/x-directory"
  source        = "/dev/null"
}
