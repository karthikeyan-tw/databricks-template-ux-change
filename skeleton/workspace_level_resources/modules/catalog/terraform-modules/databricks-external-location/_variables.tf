variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "external_location" {
  description = "External location name"
  type        = string
}

variable "storage_credential" {
  description = "Storage credential name"
  type        = string
}

variable "create_bucket" {
  description = "Create or reuse existing S3 bucket?"
  type        = string
  default     = true
}

variable "s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "s3_versioning" {
  description = "Enable S3 versioning?"
  type        = bool
  default     = false
}

variable "s3_kms_key" {
  description = "S3 KMS encryption key"
  type        = string
  default     = null
}

variable "iam_role" {
  description = "IAM role name"
  type        = string
}

variable "tags" {
  description = "AWS tags for monitoring"
  type        = map(string)
  default     = {}
}