## IAM Gule Service Role
resource "aws_iam_role" "glue_crawler_role" {
  name = "AWSGlueServiceRole-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "glue_crawler_policy" {
  name        = "glue-crawler-policy-${var.env}"
  description = "A policy for gule crawler permissions"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GlueAllowPol",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${var.s3_bucket_arn}/*",
                "${var.s3_bucket_arn}"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "glue_crawler_policy_attachment" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = aws_iam_policy.glue_crawler_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_crawler_service_role_policy_attachment" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

#
## IAM Gule Service Role
#
resource "aws_iam_role" "glue_job_role" {
  name = "AWSGlueServiceRole-${var.env}-glue-etl-jobs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "glue_job_policy" {
  name        = "glue-etl-jobs-policy-${var.env}"
  description = "A policy for gule etl jobs permissions"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GlueAllowPol",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${var.s3_bucket_arn}/*",
                "${var.s3_bucket_arn}",
                "${var.s3_bucket_arn_glue_etl}/*",
                "${var.s3_bucket_arn_glue_etl}"
            ]
        },
        {
            "Sid": "GlueAllowPolList",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${var.s3_bucket_arn_glue_etl}",
                "${var.s3_bucket_arn}"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "glue_job_policy_attachment" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = aws_iam_policy.glue_job_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_job_service_role_policy_attachment" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}