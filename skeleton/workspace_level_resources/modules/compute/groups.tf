locals {
  compute_group = {
    for item in var.clusters : item.name => {
      name = lower(replace(replace(item.name, "-", "_"), " ", "_")) # Replace hyphen and space by underscore
    }
  }
  sql_warehouse_group = {
    for item in var.sql_warehouses : item.name => {
      name = lower(replace(replace(item.name, "-", "_"), " ", "_")) # Replace hyphen and space by underscore
    }
  }
}

####################
# Compute Clusters
####################

resource "databricks_group" "compute_admin" {
  provider     = databricks.accounts
  for_each     = { for item in var.clusters : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_compute_${local.compute_group[each.key].name}_admin"
}

resource "databricks_group" "compute_user" {
  provider     = databricks.accounts
  for_each     = { for item in var.clusters : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_compute_${local.compute_group[each.key].name}_user"
}

resource "databricks_permission_assignment" "compute_admin" {
  for_each     = { for item in var.clusters : item.name => item if var.config.create_groups }
  principal_id = databricks_group.compute_admin[each.key].id
  permissions  = ["USER"]
}

resource "databricks_permission_assignment" "compute_user" {
  for_each     = { for item in var.clusters : item.name => item if var.config.create_groups }
  principal_id = databricks_group.compute_user[each.key].id
  permissions  = ["USER"]
}

##################
# SQL Warehouses
##################

resource "databricks_group" "sql_warehouse_admin" {
  provider     = databricks.accounts
  for_each     = { for item in var.sql_warehouses : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_sql_warehouse_${local.sql_warehouse_group[each.key].name}_admin"
}

resource "databricks_group" "sql_warehouse_user" {
  provider     = databricks.accounts
  for_each     = { for item in var.sql_warehouses : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_sql_warehouse_${local.sql_warehouse_group[each.key].name}_user"
}

resource "databricks_permission_assignment" "sql_warehouse_admin" {
  for_each     = { for item in var.sql_warehouses : item.name => item if var.config.create_groups }
  principal_id = databricks_group.sql_warehouse_admin[each.key].id
  permissions  = ["USER"]
}

resource "databricks_permission_assignment" "sql_warehouse_user" {
  for_each     = { for item in var.sql_warehouses : item.name => item if var.config.create_groups }
  principal_id = databricks_group.sql_warehouse_user[each.key].id
  permissions  = ["USER"]
}