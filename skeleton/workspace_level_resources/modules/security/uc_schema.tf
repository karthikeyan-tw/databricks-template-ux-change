#################################################################################################
# Unity Catalog privileges and securable objects
# https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/privileges.html
#################################################################################################

data "databricks_schema" "existing" {
  for_each = toset([for item in var.uc_privilege_schema : "${item.catalog_name}.${item.schema_name}"])
  name     = each.key
}

resource "databricks_grant" "schema" {
  for_each = {
    for item in flatten([
      for uc in var.uc_privilege_schema[*] : [
        for group in(can(uc.groups[*]) ? uc.groups[*] : []) : {
          schema     = "${uc.catalog_name}.${uc.schema_name}"
          group      = group.name
          privileges = group.privileges
        }
      ]
    ]) : "${item.schema}#${item.group}" => item
  }
  schema     = data.databricks_schema.existing[each.value.schema].name
  principal  = databricks_group.custom[each.value.group].display_name
  privileges = each.value.privileges

  depends_on = [
    data.databricks_schema.existing,
    databricks_group.custom
  ]
}