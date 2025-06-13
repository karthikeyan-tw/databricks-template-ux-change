###########################################################################
# Manage personal access token permissions
# https://docs.databricks.com/en/security/auth/api-access-permissions.html
###########################################################################

# resource "databricks_permissions" "token" {
#   count = can(var.acl_token.groups[*]) ? 1 : 0

#   authorization = "tokens"

#   dynamic "access_control" {
#     for_each = var.acl_token.groups

#     content {
#       group_name       = databricks_group.custom[access_control.value.name].display_name
#       permission_level = access_control.value.permission
#     }
#   }
# }