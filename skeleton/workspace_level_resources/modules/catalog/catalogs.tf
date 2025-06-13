resource "databricks_catalog" "catalog" {
  for_each       = { for item in var.catalogs : item.name => item }
  name           = each.value.prefix ? "${var.environment}_${replace(each.key, "-", "_")}" : replace(each.key, "-", "_")
  storage_root   = each.value.storage.enabled ? module.catalog[each.key].url : null
  isolation_mode = each.value.isolated ? "ISOLATED" : "OPEN"
}

module "catalog" {
  for_each = { for item in var.catalogs : item.name => item if item.storage.enabled }
  source   = "./terraform-modules/databricks-external-location"

  # Databricks configuration
  account_id = var.account_id

  # Databricks resources
  external_location  = "catalog-storage-${each.value.prefix ? join("-", [var.environment, replace(each.key, "_", "-")]) : replace(each.key, "_", "-")}"
  storage_credential = "catalog-credential-${each.value.prefix ? join("-", [var.environment, replace(each.key, "_", "-")]) : replace(each.key, "_", "-")}"

  # AWS resources
  s3_versioning = each.value.storage.s3_versioning
  s3_bucket     = "databricks-${var.environment}-catalog-${each.value.storage.s3_prefix == null ? replace(each.key, "_", "-") : join("-", [each.value.storage.s3_prefix, replace(each.key, "_", "-")])}-${var.region}"
  iam_role      = "databricks-${var.environment}-catalog-${replace(each.key, "_", "-")}-${var.region}"

  # AWS tags
  tags = var.tags
}