################################################################################################
# Delta Live Tables (DLT): Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#delta-live-tables-acls
################################################################################################

data "databricks_pipelines" "existing" {
  for_each      = toset([for item in var.acl_dlt : item.name])
  pipeline_name = each.key

  lifecycle {
    # Manual check: Data source doesn't return an error message when pipeline doesn't exist
    postcondition {
      condition     = length(self.ids) > 0
      error_message = "cannot read delta live tables (DLT): there is no pipeline with name '${self.pipeline_name}'"
    }
  }
}

resource "databricks_permissions" "dlt" {
  for_each    = { for item in var.acl_dlt : item.name => item }
  pipeline_id = one(data.databricks_pipelines.existing[each.key].ids)

  dynamic "access_control" {
    for_each = each.value.groups

    content {
      group_name       = databricks_group.custom[access_control.value.name].display_name
      permission_level = access_control.value.permission
    }
  }

  depends_on = [
    data.databricks_pipelines.existing,
    databricks_group.custom
  ]
}