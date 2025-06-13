# NOTE: `public_access_enabled` must be `true` until the module supports the "front-end" private link scenario
resource "databricks_mws_private_access_settings" "workspace" {
  private_access_settings_name = "${local.prefix}private-access${local.suffix}"
  region                       = var.region
  public_access_enabled        = true
}