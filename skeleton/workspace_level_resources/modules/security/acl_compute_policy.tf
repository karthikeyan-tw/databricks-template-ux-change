#################################################################################
# Compute Policy permissions
# https://docs.databricks.com/en/admin/clusters/policies.html#policy-permissions
#################################################################################

data "databricks_cluster_policy" "existing" {
  for_each = toset([for item in var.acl_compute_policy : item.name])
  name     = each.key
}

resource "time_sleep" "cluster_policy_wait" {
  create_duration = "10s"

  depends_on = [
    data.databricks_cluster_policy.existing,
    databricks_group.custom
  ]
}

resource "databricks_permissions" "compute_policy" {
  for_each          = { for item in var.acl_compute_policy : item.name => item }
  cluster_policy_id = data.databricks_cluster_policy.existing[each.key].id

  dynamic "access_control" {
    for_each = each.value.groups

    content {
      group_name       = databricks_group.custom[access_control.value.name].display_name
      permission_level = access_control.value.permission
    }
  }

  depends_on = [
    time_sleep.cluster_policy_wait
  ]
}