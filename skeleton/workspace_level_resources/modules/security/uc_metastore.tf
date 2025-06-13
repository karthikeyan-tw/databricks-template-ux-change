#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_current_metastore" "existing" {}

resource "databricks_grant" "metastore" {
  for_each   = { for item in var.uc_privilege_metastore.groups[*] : item.name => item }
  metastore  = data.databricks_current_metastore.existing.id
  principal  = databricks_group.custom[each.key].display_name
  privileges = each.value.privileges

  depends_on = [
    data.databricks_current_metastore.existing,
    databricks_group.custom
  ]
}