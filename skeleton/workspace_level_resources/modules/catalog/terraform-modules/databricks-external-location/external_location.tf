locals {
  # Values are extracted from new or existing S3 bucket based on configuration
  s3_bucket_id  = var.create_bucket ? aws_s3_bucket.location[0].id : data.aws_s3_bucket.existing[0].id
  s3_bucket_arn = var.create_bucket ? aws_s3_bucket.location[0].arn : data.aws_s3_bucket.existing[0].arn
}

resource "databricks_external_location" "location" {
  name            = var.external_location
  url             = "s3://${local.s3_bucket_id}"
  credential_name = databricks_storage_credential.location.id

  # Ignore errors since AWS API is eventually consistent
  skip_validation = true

  depends_on = [
    time_sleep.wait
  ]
}

# This workaround fixes the IAM role / policy propagation delay.
# The following error can happen in case we don't apply this technique:
#
# Error: cannot create external location: AWS IAM role does not have
#  READ permissions on url s3://<bucket_name>/<user_home_folder>.
#  Please contact your account admin to update the storage credential.
#
# Solution suggested via Databricks Knowledge Base and available here:
#  https://kb.databricks.com/terraform/failed-credential-validation-checks-error-with-terraform
resource "time_sleep" "wait" {
  create_duration = "10s"

  depends_on = [
    databricks_storage_credential.location,
    aws_iam_role.location
  ]
}

data "aws_s3_bucket" "existing" {
  count  = var.create_bucket ? 0 : 1
  bucket = var.s3_bucket
}

resource "aws_s3_bucket" "location" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.s3_bucket
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "location" {
  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.location[0].id

  versioning_configuration {
    status = var.s3_versioning ? "Enabled" : "Disabled"
  }
}

# Databricks recommends retaining 3 versions and implementing a lifecycle management policy
#  that retains versions for 7 days or less for all S3 buckets with versioning enabled.
# https://docs.databricks.com/en/delta/s3-limitations.html#bucket-versioning-and-delta-lake
resource "aws_s3_bucket_lifecycle_configuration" "location" {
  count  = var.create_bucket && var.s3_versioning ? 1 : 0
  bucket = aws_s3_bucket_versioning.location[0].id

  rule {
    id = "databricks-recommended-s3-versioning"

    noncurrent_version_expiration {
      newer_noncurrent_versions = 3
      noncurrent_days           = 7
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "location" {
  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.location[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}