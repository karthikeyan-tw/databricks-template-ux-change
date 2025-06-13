resource "aws_s3_bucket" "metastore" {
  count  = var.metastore.storage.enabled ? 1 : 0
  bucket = "databricks-metastore-${var.metastore.storage.s3_prefix == null ? var.region : join("-", [var.metastore.storage.s3_prefix, var.region])}"
  force_destroy = true
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "metastore" {
  count  = var.metastore.storage.enabled ? 1 : 0
  bucket = aws_s3_bucket.metastore[0].id

  versioning_configuration {
    status = var.metastore.storage.s3_versioning ? "Enabled" : "Disabled"
  }
}

# Databricks recommends retaining 3 versions and implementing a lifecycle management policy
#  that retains versions for 7 days or less for all S3 buckets with versioning enabled.
# https://docs.databricks.com/en/delta/s3-limitations.html#bucket-versioning-and-delta-lake
resource "aws_s3_bucket_lifecycle_configuration" "metastore" {
  count  = var.metastore.storage.enabled && var.metastore.storage.s3_versioning ? 1 : 0
  bucket = aws_s3_bucket_versioning.metastore[0].id

  rule {
    id = "databricks-recommended-s3-versioning"

    noncurrent_version_expiration {
      newer_noncurrent_versions = 3
      noncurrent_days           = 7
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "metastore" {
  count  = var.metastore.storage.enabled ? 1 : 0
  bucket = aws_s3_bucket.metastore[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}