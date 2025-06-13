#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_catalog" "existing" {
  for_each = toset([for item in var.uc_privilege_catalog : item.catalog_name])
  name     = each.key
}

resource "databricks_grant" "catalog" {
  for_each = {
    for item in flatten([
      for uc in var.uc_privilege_catalog[*] : [
        for group in(can(uc.groups[*]) ? uc.groups[*] : []) : {
          catalog    = uc.catalog_name
          group      = group.name
          privileges = group.privileges
        }
      ]
    ]) : "${item.catalog}#${item.group}" => item
  }
  catalog    = data.databricks_catalog.existing[each.value.catalog].name
  principal  = databricks_group.custom[each.value.group].display_name
  privileges = each.value.privileges

  depends_on = [
    data.databricks_catalog.existing,
    databricks_group.custom
  ]
}