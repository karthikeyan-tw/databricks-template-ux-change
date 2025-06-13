#####################################################################################
# Secret: Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#secret-acls
#####################################################################################

resource "databricks_secret_acl" "scope" {
  for_each = {
    for item in flatten([
      for scope in var.acl_secret : [
        for group in scope.groups : {
          secret_scope = scope.name
          group        = group.name
          permission   = group.permission
        }
      ]
    ]) : "${item.secret_scope}#${item.group}" => item
  }
  scope      = each.value.secret_scope
  principal  = databricks_group.custom[each.value.group].display_name
  permission = each.value.permission

  depends_on = [
    databricks_group.custom
  ]
}