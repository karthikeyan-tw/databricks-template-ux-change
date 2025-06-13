resource "databricks_metastore" "metastore" {
  name          = "metastore-${var.region}"
  storage_root  = var.metastore.storage.enabled ? "s3://${aws_s3_bucket.metastore[0].id}" : null
  region        = var.region
  force_destroy = true
}