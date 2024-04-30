## S3 bucket for the data lake
resource "aws_s3_bucket" "data_lake" {
  bucket = "${var.s3_bucket_name}-${var.env}"
}

resource "aws_s3_bucket_versioning" "data_lake_bucket_versioning" {
  bucket = aws_s3_bucket.data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "data_lake_bucket_ownership" {
  bucket = aws_s3_bucket.data_lake.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "data_lake_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.data_lake_bucket_ownership]

  bucket = aws_s3_bucket.data_lake.id
  acl    = "private"
}

## Deploy inital medallion architecture buckets
resource "aws_s3_object" "create_bronze_dir" {
  bucket = aws_s3_bucket.data_lake.bucket
  key    = "bronze/"
  content_type = "application/x-directory"
  source = "/dev/null"
}

resource "aws_s3_object" "create_silver_dir" {
  bucket = aws_s3_bucket.data_lake.bucket
  key    = "silver/"
  content_type = "application/x-directory"
  source = "/dev/null"
}

resource "aws_s3_object" "create_gold_dir" {
  bucket = aws_s3_bucket.data_lake.bucket
  key    = "gold/"
  content_type = "application/x-directory"
  source = "/dev/null"
}


## S3 bucket ETL Job Storage
resource "aws_s3_bucket" "glue_etl_jobs" {
  bucket = "${var.s3_bucket_name}-${var.env}-glue-etl-jobs"
}


## Lifecyle Policy
resource "aws_s3_bucket_lifecycle_configuration" "data_lifecyle_policy" {  
  bucket = aws_s3_bucket.data_lake.bucket

  rule {
    id = "${var.env}-bronze"

    filter {
      prefix = "${var.s3_bucket_name}/bronze/"
    }

    expiration {
      days = var.data_age_out_expiration_bronze
    }

    transition {
      days          = var.data_lifecycle_standard_ia_bronze
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.data_lifecycle_glacier_bronze
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }

  rule {
    id = "${var.env}-silver"

    filter {
      prefix = "${var.s3_bucket_name}/silver/"
    }

    expiration {
      days = var.data_age_out_expiration_silver
    }

    transition {
      days          = var.data_lifecycle_standard_ia_silver
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.data_lifecycle_glacier_silver
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }

  rule {
    id = "${var.env}-gold"

    filter {
      prefix = "${var.s3_bucket_name}/gold/"
    }

    expiration {
      days = var.data_age_out_expiration_gold
    }

    transition {
      days          = var.data_lifecycle_standard_ia_gold
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.data_lifecycle_glacier_gold
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}
