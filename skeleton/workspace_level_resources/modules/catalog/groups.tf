################################################################################
# Catalogs
################################################################################

resource "databricks_group" "data_reader" {
  provider     = databricks.accounts
  for_each     = { for item in var.catalogs : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_catalog_${databricks_catalog.catalog[each.key].name}_reader"
}

resource "databricks_group" "data_admin" {
  provider     = databricks.accounts
  for_each     = { for item in var.catalogs : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_catalog_${databricks_catalog.catalog[each.key].name}_admin"
}

resource "databricks_permission_assignment" "data_reader" {
  for_each     = { for item in var.catalogs : item.name => item if var.config.create_groups }
  principal_id = databricks_group.data_reader[each.key].id
  permissions  = ["USER"]
}

resource "databricks_permission_assignment" "data_admin" {
  for_each     = { for item in var.catalogs : item.name => item if var.config.create_groups }
  principal_id = databricks_group.data_admin[each.key].id
  permissions  = ["USER"]
}

################################################################################
# External Locations
################################################################################

resource "databricks_group" "external_location_writer" {
  provider     = databricks.accounts
  for_each     = { for item in var.external_locations : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_external_${replace(each.key, "-", "_")}_writer"
}

resource "databricks_group" "external_location_admin" {
  provider     = databricks.accounts
  for_each     = { for item in var.external_locations : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_external_${replace(each.key, "-", "_")}_admin"
}

resource "databricks_permission_assignment" "external_location_writer" {
  for_each     = { for item in var.external_locations : item.name => item if var.config.create_groups }
  principal_id = databricks_group.external_location_writer[each.key].id
  permissions  = ["USER"]
}

resource "databricks_permission_assignment" "external_location_admin" {
  for_each     = { for item in var.external_locations : item.name => item if var.config.create_groups }
  principal_id = databricks_group.external_location_admin[each.key].id
  permissions  = ["USER"]
}