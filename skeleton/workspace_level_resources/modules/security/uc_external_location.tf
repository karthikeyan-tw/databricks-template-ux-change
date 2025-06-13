#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_external_location" "existing" {
  for_each = toset([for item in var.uc_privilege_location : item.name])
  name     = each.key
}

resource "databricks_grant" "external_location" {
  for_each = {
    for item in flatten([
      for uc in var.uc_privilege_location[*] : [
        for group in(can(uc.groups[*]) ? uc.groups[*] : []) : {
          external_location = uc.name
          group             = group.name
          privileges        = group.privileges
        }
      ]
    ]) : "${item.external_location}#${item.group}" => item
  }
  external_location = data.databricks_external_location.existing[each.value.external_location].name
  principal         = databricks_group.custom[each.value.group].display_name
  privileges        = each.value.privileges

  depends_on = [
    data.databricks_external_location.existing,
    databricks_group.custom
  ]
}