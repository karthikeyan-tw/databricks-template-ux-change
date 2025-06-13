#######################################################################################
# Compute Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#compute-acls
#######################################################################################

resource "databricks_permissions" "compute_acl" {
  for_each   = { for item in var.clusters : item.name => item if var.config.create_groups }
  cluster_id = databricks_cluster.compute[each.key].id

  access_control {
    group_name       = databricks_group.compute_admin[each.key].display_name
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = databricks_group.compute_user[each.key].display_name
    permission_level = var.config.can_restart ? "CAN_RESTART" : "CAN_ATTACH_TO"
  }
}

#############################################################################################
# SQL Warehouse Access Control Lists (ACLs)
# https://docs.databricks.com/en/security/auth/access-control/index.html#sql-warehouse-acls
#############################################################################################

resource "databricks_permissions" "sql_warehouse_acl" {
  for_each        = { for item in var.sql_warehouses : item.name => item if var.config.create_groups }
  sql_endpoint_id = databricks_sql_endpoint.compute[each.key].id

  access_control {
    group_name       = databricks_group.sql_warehouse_admin[each.key].display_name
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = databricks_group.sql_warehouse_user[each.key].display_name
    permission_level = "CAN_USE"
  }
}