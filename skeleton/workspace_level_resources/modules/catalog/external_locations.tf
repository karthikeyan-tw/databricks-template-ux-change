module "external_location" {
  for_each = { for item in var.external_locations : item.name => item }
  source   = "./terraform-modules/databricks-external-location"

  # Databricks configuration
  account_id = var.account_id

  # Databricks resources
  external_location  = "external-storage-${var.environment}-${replace(each.key, "_", "-")}"
  storage_credential = "external-credential-${var.environment}-${replace(each.key, "_", "-")}"

  # AWS resources
  create_bucket = each.value.storage.create_bucket
  s3_versioning = each.value.storage.s3_versioning
  s3_kms_key    = each.value.storage.s3_kms_key

  s3_bucket = (each.value.storage.create_bucket ?
    # 1. Calculate name for new S3 bucket or...
    "databricks-${var.environment}-external-${each.value.storage.s3_prefix == null ? replace(each.key, "_", "-") : join("-", [each.value.storage.s3_prefix, replace(each.key, "_", "-")])}-${var.region}" :
    # 2. Provide name of existing S3 bucket
    each.value.storage.s3_bucket
  )

  iam_role = "databricks-${var.environment}-external-${replace(each.key, "_", "-")}-${var.region}"

  # AWS tags
  tags = var.tags
}