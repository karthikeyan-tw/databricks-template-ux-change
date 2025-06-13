resource "databricks_compliance_security_profile_workspace_setting" "compliance" {
  count = var.security_profile.enabled ? 1 : 0

  compliance_security_profile_workspace {
    is_enabled           = var.security_profile.enabled
    compliance_standards = var.security_profile.compliance_standards
  }
}
resource "databricks_enhanced_security_monitoring_workspace_setting" "compliance" {
  count = var.security_profile.enabled ? 1 : 0

  enhanced_security_monitoring_workspace {
    is_enabled = var.security_profile.enabled
  }
}