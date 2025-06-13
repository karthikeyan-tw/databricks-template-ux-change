variable "environment" {
  description = "Databricks environment name"
  type        = string
}

variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "workspace" {
  description = "Databricks workspace name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "clusters" {
  description = "Databricks clusters"

  type = list(
    object({
      name                 = string
      spark_version        = optional(string, "LTS")
      photon               = optional(bool, true)
      driver_instance_type = optional(string, null)
      instance_type        = optional(string, "m5.large")
      min_workers          = optional(number, 1)
      max_workers          = optional(number, 1)
      auto_terminate       = optional(number, 20) # in minutes
      spark_env_vars       = optional(map(string))
      spark_conf           = optional(map(string))
      on_demand = optional(object({
        composition          = optional(string, "DRIVER_ONLY")
        bid_price_percentage = optional(number, 100)
      }))
    })
  )
}

variable "sql_warehouses" {
  description = "Databricks SQL warehouses"

  type = list(
    object({
      name                 = string
      size                 = optional(string, "2X-Small")
      photon               = optional(bool, true)
      serverless           = optional(bool, false)
      min_clusters         = optional(number, 1)
      max_clusters         = optional(number, 1)
      auto_terminate       = optional(number, 20) # in minutes
      spot_instance_policy = optional(string, "COST_OPTIMIZED")
    })
  )
}

variable "monitoring" {
  description = "Monitoring integration"

  type = object({
    datadog    = optional(bool, false)
    cloudwatch = optional(bool, false)
  })
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
  default     = null
}

variable "config" {
  description = "Databricks Accelerator configuration"

  type = object({
    can_restart   = optional(bool, false)
    create_groups = optional(bool, true)
  })
}

variable "tags" {
  description = "AWS tags for monitoring"
  type        = map(string)
  default     = {}
}

variable "deployment_name_prefix" {
  description = "Prefix for deployment names"
  type        = string
  default     = ""
}