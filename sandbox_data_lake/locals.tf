locals {
  glue_database_names = {
    bronze = module.glue_database_creation_bronze.glue_database_name,
    silver = module.glue_database_creation_silver.glue_database_name,
    gold   = module.glue_database_creation_gold.glue_database_name
  }
}