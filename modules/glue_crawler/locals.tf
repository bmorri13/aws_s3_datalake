locals {
  s3_exclude_paths = [for blob in var.crawler_exclude_blobs : format(
    "%s/%s",
    blob,
    "**"
  )]
}