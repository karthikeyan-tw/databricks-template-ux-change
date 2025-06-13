data "databricks_metastores" "all" {}

resource "databricks_metastore_assignment" "workspace" {
  for_each     = { for item in var.workspaces : item.name => item if var.metastore != null }
  metastore_id = data.databricks_metastores.all.ids[var.metastore]
  workspace_id = databricks_mws_workspaces.workspace[each.key].workspace_id
}