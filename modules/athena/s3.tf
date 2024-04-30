resource "aws_s3_bucket" "athena_bucket_name" {
  bucket = var.athena_bucket_name
}

resource "aws_s3_bucket_versioning" "athena_bucket_versioning" {
  bucket = aws_s3_bucket.athena_bucket_name.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "athena_bucket_ownership" {
  bucket = aws_s3_bucket.athena_bucket_name.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "athena_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.athena_bucket_ownership]

  bucket = aws_s3_bucket.athena_bucket_name.id
  acl    = "private"
}
