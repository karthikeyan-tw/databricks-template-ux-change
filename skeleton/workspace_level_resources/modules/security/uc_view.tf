#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_views" "existing" {
  for_each     = { for item in var.uc_privilege_view : "${item.catalog_name}.${item.schema_name}.${item.view_name}" => item }
  catalog_name = each.value.catalog_name
  schema_name  = each.value.schema_name

  lifecycle {
    # Manual check: Data source doesn't return an error message when view doesn't exist
    postcondition {
      condition     = contains(self.ids, each.key)
      error_message = "cannot read view: View '${each.key}' does not exist."
    }
  }
}

resource "databricks_grant" "view" {
  for_each = {
    for item in flatten([
      for uc in var.uc_privilege_view[*] : [
        for group in(can(uc.groups[*]) ? uc.groups[*] : []) : {
          view       = "${uc.catalog_name}.${uc.schema_name}.${uc.view_name}"
          group      = group.name
          privileges = group.privileges
        }
      ]
    ]) : "${item.view}#${item.group}" => item
  }
  table      = each.value.view
  principal  = databricks_group.custom[each.value.group].display_name
  privileges = each.value.privileges

  depends_on = [
    data.databricks_views.existing,
    databricks_group.custom
  ]
}