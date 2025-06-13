############################################################################################
# SQL Warehouse: Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#sql-warehouse-acls
############################################################################################

data "databricks_sql_warehouse" "existing" {
  for_each = toset([for item in var.acl_sql_warehouse : item.name])
  name     = each.key
}

resource "time_sleep" "sql_warehouse_wait" {
  create_duration = "10s"

  depends_on = [
   data.databricks_sql_warehouse.existing,
    databricks_group.custom
  ]
}

resource "databricks_permissions" "sql_warehouse" {
  for_each        = { for item in var.acl_sql_warehouse : item.name => item }
  sql_endpoint_id = data.databricks_sql_warehouse.existing[each.key].id

  dynamic "access_control" {
    for_each = each.value.groups

    content {
      group_name       = databricks_group.custom[access_control.value.name].display_name
      permission_level = access_control.value.permission
    }
  }

  depends_on = [
    time_sleep.sql_warehouse_wait
  ]
}
