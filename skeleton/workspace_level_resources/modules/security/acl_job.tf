##################################################################################
# Job: Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#job-acls
##################################################################################

data "databricks_job" "existing" {
  for_each = toset([for item in var.acl_job : item.name])
  job_name = each.key
}

resource "databricks_permissions" "job" {
  for_each = { for item in var.acl_job : item.name => item }
  job_id   = data.databricks_job.existing[each.key].id

  dynamic "access_control" {
    for_each = each.value.groups

    content {
      group_name       = databricks_group.custom[access_control.value.name].display_name
      permission_level = access_control.value.permission
    }
  }

  depends_on = [
    data.databricks_job.existing,
    databricks_group.custom
  ]
}