################################################################################
# New Groups
################################################################################

resource "databricks_group" "custom" {
  provider     = databricks.accounts
  for_each     = { for item in var.groups : item.name => item }
  display_name = "da_${var.environment}_${replace(each.value.name, "-", "_")}"
}

resource "databricks_entitlements" "custom" {
  for_each                   = { for item in var.groups : item.name => item }
  group_id                   = databricks_group.custom[each.key].id
  allow_cluster_create       = can(each.value.entitlements.allow_cluster_create) ? each.value.entitlements.allow_cluster_create : false
  allow_instance_pool_create = can(each.value.entitlements.allow_instance_pool_create) ? each.value.entitlements.allow_instance_pool_create : false
  databricks_sql_access      = can(each.value.entitlements.databricks_sql_access) ? each.value.entitlements.databricks_sql_access : false
  workspace_access           = can(each.value.entitlements.workspace_access) ? each.value.entitlements.workspace_access : false

  depends_on = [
    databricks_permission_assignment.custom
  ]
}

resource "databricks_permission_assignment" "custom" {
  for_each     = { for item in var.groups : item.name => item }
  principal_id = databricks_group.custom[each.key].id
  permissions  = ["USER"]
}