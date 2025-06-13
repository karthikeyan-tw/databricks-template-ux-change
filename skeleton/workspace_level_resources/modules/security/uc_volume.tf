#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_volume" "existing" {
  for_each = toset([for item in var.uc_privilege_volume : "${item.catalog_name}.${item.schema_name}.${item.volume_name}"])
  name     = each.key
}

resource "databricks_grant" "volume" {
  for_each = {
    for item in flatten([
      for uc in var.uc_privilege_volume[*] : [
        for group in(can(uc.groups[*]) ? uc.groups[*] : []) : {
          volume     = "${uc.catalog_name}.${uc.schema_name}.${uc.volume_name}"
          group      = group.name
          privileges = group.privileges
        }
      ]
    ]) : "${item.volume}#${item.group}" => item
  }
  volume     = data.databricks_volume.existing[each.value.volume].name
  principal  = databricks_group.custom[each.value.group].display_name
  privileges = each.value.privileges
  
  depends_on = [
    data.databricks_volume.existing,
    databricks_group.custom
  ]
}