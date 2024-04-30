## Establish Data lake IAM role and permissions
## IAM role to register lake location
resource "aws_iam_role" "lake_formation_service_role" {
  name = "${var.s3_bucket_name}-data-access-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lakeformation.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "data_lake_access" {
  name        = "${var.s3_bucket_name}-data-access-pol-${var.env}"
  description = "Policy for accessing the Data Lake S3 bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LakeFormationDataAccessPermissionsForS3",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.data_lake.arn}/*"
            ]
        },
        {
            "Sid": "LakeFormationDataAccessPermissionsForS3ListBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.data_lake.arn}/*"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "data_lake_access_attachment" {
  role       = aws_iam_role.lake_formation_service_role.name
  policy_arn = aws_iam_policy.data_lake_access.arn
}

## Registers the data lake location to the IAM Role (ie.) Data lake locations tab)
resource "aws_lakeformation_resource" "data_lake_s3" {
  role_arn                  = aws_iam_role.lake_formation_service_role.arn
  arn                       = aws_s3_bucket.data_lake.arn
  hybrid_access_enabled     = true
}