#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_table" "existing" {
  for_each = toset([for item in var.uc_privilege_table : "${item.catalog_name}.${item.schema_name}.${item.table_name}"])
  name     = each.key
}

resource "databricks_grant" "table" {
  for_each = {
    for item in flatten([
      for uc in var.uc_privilege_table[*] : [
        for group in(can(uc.groups[*]) ? uc.groups[*] : []) : {
          table      = "${uc.catalog_name}.${uc.schema_name}.${uc.table_name}"
          group      = group.name
          privileges = group.privileges
        }
      ]
    ]) : "${item.table}#${item.group}" => item
  }
  table      = data.databricks_table.existing[each.value.table].name
  principal  = databricks_group.custom[each.value.group].display_name
  privileges = each.value.privileges

  depends_on = [
    data.databricks_table.existing,
    databricks_group.custom
  ]
}