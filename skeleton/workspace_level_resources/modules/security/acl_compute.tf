#######################################################################################
# Compute: Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#compute-acls
#######################################################################################

data "databricks_cluster" "existing" {
  for_each     = toset([for item in var.acl_compute : item.name])
  cluster_name = each.key
}

resource "time_sleep" "acl_compute_wait" {
  create_duration = "10s"

  depends_on = [
    data.databricks_cluster.existing,
    databricks_group.custom
  ]
}

resource "databricks_permissions" "compute" {
  for_each   = { for item in var.acl_compute : item.name => item }
  cluster_id = data.databricks_cluster.existing[each.key].id

  dynamic "access_control" {
    for_each = each.value.groups

    content {
      group_name       = databricks_group.custom[access_control.value.name].display_name
      permission_level = access_control.value.permission
    }
  }

  depends_on = [
    time_sleep.acl_compute_wait
  ]
}