variable workspace_name {
  type        = string
  description = "The name of the workspace"
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
  default     = null
}