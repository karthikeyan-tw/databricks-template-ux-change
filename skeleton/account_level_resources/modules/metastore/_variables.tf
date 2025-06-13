variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "metastore" {
  description = "Databricks metastore configuration"

  type = object({
    storage = object({
      enabled       = optional(bool, false)
      s3_prefix     = optional(string)
      s3_versioning = optional(bool, false)
    })
  })

  validation {
    condition = !(
      var.metastore.storage.enabled &&
      (
        var.metastore.storage.s3_prefix == null ||
        var.metastore.storage.s3_prefix == ""
      )
    )
    error_message = "The S3 prefix is required when storage is enabled."
  }
}

variable "tags" {
  description = "AWS tags for monitoring"
  type        = map(string)
  default     = {}
}