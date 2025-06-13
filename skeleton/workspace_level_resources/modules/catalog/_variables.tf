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

variable "catalogs" {
  description = "Databricks catalogs"

  type = list(
    object({
      name   = string
      prefix = optional(bool, true)
      storage = object({
        enabled       = optional(bool, true)
        s3_prefix     = optional(string)
        s3_versioning = optional(bool, false)
      })
      isolated = optional(bool, true)
      visible  = optional(bool, true)
      schemas  = optional(set(string))
    })
  )

  validation {
    condition = length(var.catalogs) == 0 ? true : alltrue([
      for catalog in var.catalogs : (
        !(catalog.storage.enabled && (catalog.storage.s3_prefix == null || catalog.storage.s3_prefix == ""))
      )
    ])
    error_message = "The S3 prefix is required when storage is enabled."
  }
}

variable "external_locations" {
  description = "Databricks external locations"

  type = list(
    object({
      name = string
      storage = object({
        create_bucket = optional(bool, true)
        s3_prefix     = optional(string)
        s3_bucket     = optional(string)
        s3_versioning = optional(bool, false)
        s3_kms_key    = optional(string, null)
      })
      visible = optional(bool, true)
    })
  )

  validation {
    condition = length(var.external_locations) == 0 ? true : alltrue([
      for extloc in var.external_locations : (
        !(!extloc.storage.create_bucket && (extloc.storage.s3_bucket == null || extloc.storage.s3_bucket == ""))
      )
    ])
    error_message = "The S3 bucket is required when storage already exists."
  }

  validation {
    condition = length(var.external_locations) == 0 ? true : alltrue([
      for extloc in var.external_locations : (
        !(extloc.storage.create_bucket && (extloc.storage.s3_prefix == null || extloc.storage.s3_prefix == ""))
      )
    ])
    error_message = "The S3 prefix is required when storage is created by the module."
  }

  validation {
    condition = length(var.external_locations) == 0 ? true : alltrue([
      for extloc in var.external_locations : (
        !(!extloc.storage.create_bucket && extloc.storage.s3_versioning)
      )
    ])
    error_message = "The S3 versioning can't be configured in existing S3 buckets."
  }
}

variable "config" {
  description = "Databricks Accelerator configuration"

  type = object({
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