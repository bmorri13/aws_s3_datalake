locals {
  silver_glue_src_path = "${path.root}/${var.env}_data_lake/data_sources/${var.data_source_name}/code/"
  silver_file_name = "silver_etl_job.py"
}
