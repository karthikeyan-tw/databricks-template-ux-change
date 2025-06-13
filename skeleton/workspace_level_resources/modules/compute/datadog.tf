resource "databricks_workspace_file" "datadog_agent" {
  count  = var.monitoring.datadog ? 1 : 0
  source = "${path.module}/monitoring/datadog-init.sh"
  path   = "/Shared/monitoring/datadog-init.sh"
}

resource "databricks_secret_scope" "datadog" {
  count = var.monitoring.datadog ? 1 : 0
  name  = "datadog"
}

resource "databricks_secret" "api_key" {
  count        = var.monitoring.datadog ? 1 : 0
  scope        = databricks_secret_scope.datadog[0].id
  key          = "api_key"
  string_value = var.datadog_api_key
}