resource "databricks_group" "workspace_admin" {
  for_each     = { for item in var.workspaces : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_workspace_${replace(databricks_mws_workspaces.workspace[each.key].workspace_name, "-", "_")}_admin"
}

resource "databricks_group" "workspace_user" {
  for_each     = { for item in var.workspaces : item.name => item if var.config.create_groups }
  display_name = "da_${var.environment}_workspace_${replace(databricks_mws_workspaces.workspace[each.key].workspace_name, "-", "_")}_user"
}

resource "databricks_mws_permission_assignment" "workspace_admin" {
  for_each     = { for item in var.workspaces : item.name => item if var.config.create_groups }
  workspace_id = databricks_mws_workspaces.workspace[each.key].workspace_id
  principal_id = databricks_group.workspace_admin[each.key].id
  permissions  = ["ADMIN"]

  depends_on = [databricks_metastore_assignment.workspace]
}

resource "databricks_mws_permission_assignment" "workspace_user" {
  for_each     = { for item in var.workspaces : item.name => item if var.config.create_groups }
  workspace_id = databricks_mws_workspaces.workspace[each.key].workspace_id
  principal_id = databricks_group.workspace_user[each.key].id
  permissions  = ["USER"]

  depends_on = [databricks_metastore_assignment.workspace]
}