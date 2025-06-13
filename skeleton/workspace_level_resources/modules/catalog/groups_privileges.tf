locals {
  # Reference: https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html#privilege-types-by-securable-object-in-unity-catalog
  catalog = {
    reader_privileges = [
      "USE_CATALOG",
      "USE_SCHEMA",
      "EXECUTE",
      "READ_VOLUME",
      "SELECT",
    ]
  }

  external_location = {
    writer_privileges = [
      "READ_FILES",
      "WRITE_FILES",
    ]
  }
}

################################################################################
# Catalogs
################################################################################

resource "databricks_grant" "catalog_browse" {
  for_each   = { for item in var.catalogs : item.name => item if item.visible }
  catalog    = databricks_catalog.catalog[each.key].name
  principal  = "account users" # All account users
  privileges = ["BROWSE"]
}

resource "databricks_grant" "catalog_external_location_browse" {
  for_each          = { for item in var.catalogs : item.name => item if item.visible }
  external_location = module.catalog[each.key].id
  principal         = "account users" # All account users
  privileges        = ["BROWSE"]
}

resource "databricks_grant" "catalog_data_reader" {
  for_each   = { for item in var.catalogs : item.name => item if var.config.create_groups }
  catalog    = databricks_catalog.catalog[each.key].name
  principal  = databricks_group.data_reader[each.key].display_name
  privileges = local.catalog.reader_privileges
}

resource "databricks_grant" "catalog_data_admin" {
  for_each   = { for item in var.catalogs : item.name => item if var.config.create_groups }
  catalog    = databricks_catalog.catalog[each.key].name
  principal  = databricks_group.data_admin[each.key].display_name
  privileges = ["ALL_PRIVILEGES"]
}

################################################################################
# External Locations
################################################################################

resource "databricks_grant" "external_location_browse" {
  for_each          = { for item in var.external_locations : item.name => item if item.visible }
  external_location = module.external_location[each.key].id
  principal         = "account users" # All account users
  privileges        = ["BROWSE"]
}

resource "databricks_grant" "external_location_writer" {
  for_each          = { for item in var.external_locations : item.name => item if var.config.create_groups }
  external_location = module.external_location[each.key].id
  principal         = databricks_group.external_location_writer[each.key].display_name
  privileges        = local.external_location.writer_privileges
}

resource "databricks_grant" "external_location_admin" {
  for_each          = { for item in var.external_locations : item.name => item if var.config.create_groups }
  external_location = module.external_location[each.key].id
  principal         = databricks_group.external_location_admin[each.key].display_name
  privileges        = ["ALL_PRIVILEGES"]
}