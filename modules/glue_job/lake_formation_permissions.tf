## Add Data Lake DB Permissions
resource "aws_lakeformation_permissions" "glue_database_permissions" { 
  count = length(var.glue_db_iam_allowed_arns)

  permissions = ["ALL"]
  principal   = var.glue_db_iam_allowed_arns[count.index]

  database {
    name = var.glue_db_name
  }
}

resource "aws_lakeformation_permissions" "glue_database_permissions_table" {
  count = length(var.glue_db_iam_allowed_arns)

  permissions = ["ALL"]
  principal   = var.glue_db_iam_allowed_arns[count.index]
  
  table {
    database_name = var.glue_db_name
    wildcard      = true
  }
}
