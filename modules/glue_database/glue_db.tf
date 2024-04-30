## Create Glue DB
resource "aws_glue_catalog_database" "glue_database" {
  name = "${var.data_tier}-${var.env}"
  location_uri = "s3://${var.s3_bucket_name}/${var.data_tier}/"
  description = "Database for ${var.data_tier}-${var.env} data"

  create_table_default_permission {
    permissions = ["SELECT"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}