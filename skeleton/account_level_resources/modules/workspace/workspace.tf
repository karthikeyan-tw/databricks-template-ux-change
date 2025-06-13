resource "databricks_mws_workspaces" "workspace" {
  for_each   = { for item in var.workspaces : item.name => item }
  account_id = var.account_id
  aws_region = var.region

  workspace_name  = "${local.prefix}${each.key}${local.suffix}"
  deployment_name = "${local.prefix}${each.key}${local.suffix}"

  credentials_id             = databricks_mws_credentials.workspace.credentials_id
  storage_configuration_id   = databricks_mws_storage_configurations.workspace[each.value.storage].storage_configuration_id
  network_id                 = try(databricks_mws_networks.workspace[each.value.network].network_id, null)
  private_access_settings_id = each.value.private_access ? databricks_mws_private_access_settings.workspace.private_access_settings_id : null

  managed_services_customer_managed_key_id = try(databricks_mws_customer_managed_keys.workspace[each.value.encryption.managed_services].customer_managed_key_id, null)
  storage_customer_managed_key_id          = try(databricks_mws_customer_managed_keys.workspace[each.value.encryption.storage].customer_managed_key_id, null)
}