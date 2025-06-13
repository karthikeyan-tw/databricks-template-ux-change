resource "databricks_mws_storage_configurations" "workspace" {
  for_each                   = { for item in var.storage : item.name => item }
  account_id                 = var.account_id
  storage_configuration_name = "${local.prefix}${each.key}${local.suffix}"
  bucket_name                = aws_s3_bucket.root_storage[each.key].id
}

resource "aws_s3_bucket" "root_storage" {
  for_each = { for item in var.storage : item.name => item }
  bucket   = "databricks-${var.environment}-storage-${each.value.s3_prefix == null ? each.key : join("-", [each.value.s3_prefix, each.key])}-${var.region}"
  force_destroy = true
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "root_storage" {
  for_each = { for item in var.storage : item.name => item }
  bucket   = aws_s3_bucket.root_storage[each.key].id

  versioning_configuration {
    status = each.value.s3_versioning ? "Enabled" : "Disabled"
  }
}

# Databricks recommends retaining 3 versions and implementing a lifecycle management policy
#  that retains versions for 7 days or less for all S3 buckets with versioning enabled.
# https://docs.databricks.com/en/delta/s3-limitations.html#bucket-versioning-and-delta-lake
resource "aws_s3_bucket_lifecycle_configuration" "root_storage" {
  for_each = { for item in var.storage : item.name => item if item.s3_versioning }
  bucket   = aws_s3_bucket_versioning.root_storage[each.key].id

  rule {
    id = "databricks-recommended-s3-versioning"

    noncurrent_version_expiration {
      newer_noncurrent_versions = 3
      noncurrent_days           = 7
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_storage" {
  for_each = { for item in var.storage : item.name => item }
  bucket   = aws_s3_bucket.root_storage[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "root_storage" {
  for_each = { for item in var.storage : item.name => item }
  bucket   = aws_s3_bucket.root_storage[each.key].id
  policy   = data.aws_iam_policy_document.bucket_policy[each.key].json
}

data "aws_iam_policy_document" "bucket_policy" {
  for_each = { for item in var.storage : item.name => item }

  statement {
    sid    = "Grant Databricks Access"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:root"] # TODO: Transfer DBX AWS account root to a constant
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.root_storage[each.key].arn,
      "${aws_s3_bucket.root_storage[each.key].arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = [var.account_id]
    }
  }
}