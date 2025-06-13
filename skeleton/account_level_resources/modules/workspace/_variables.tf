variable "environment" {
  description = "Databricks environment name"
  type        = string
}

variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "metastore" {
  description = "Databricks metastore name"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "workspaces" {
  description = "Databricks workspaces"

  type = list(
    object({
      name           = string
      storage        = string
      network        = optional(string)
      private_access = optional(bool, false)
      encryption = optional(object({
        managed_services = optional(string)
        storage          = optional(string)
      }))
    })
  )
}

variable "credential" {
  description = "Databricks credential"

  type = object({
    policy = optional(string, "managed")
  })

  validation {
    condition     = contains(["managed", "customer"], var.credential.policy)
    error_message = "The credential policy must be \"managed\" or \"customer\"."
  }
}

variable "storage" {
  description = "Databricks storage"

  type = list(
    object({
      name          = string
      s3_prefix     = optional(string)
      s3_versioning = optional(bool, false)
    })
  )
}

variable "network" {
  description = "Databricks network"

  type = list(
    object({
      name             = string
      cidr_block       = optional(string, null)
      ipam_pool_id     = optional(string, null)
      netmask_length   = optional(number, null)
      internet_gateway = optional(bool, false)
      nat_gateway      = optional(bool, false)
      private_link     = optional(bool, false)
      vpc_flow_logs    = optional(bool, false)
    })
  )

  validation {
    condition = length(var.network) == 0 ? true : alltrue([
      for network in var.network : (
        !(network.cidr_block != null && network.ipam_pool_id != null)
      )
    ])
    error_message = "You must define (exactly) one CIDR configuration per network (cidr_block or ipam_pool_id)."
  }

  validation {
    condition = length(var.network) == 0 ? true : alltrue([
      for network in var.network : (
        !(network.cidr_block == null && network.ipam_pool_id == null)
      )
    ])
    error_message = "You must define (at least) one CIDR configuration per network (cidr_block or ipam_pool_id)."
  }

  validation {
    condition = length(var.network) == 0 ? true : alltrue([
      for network in var.network : (
        !(network.cidr_block != null && network.netmask_length != null)
      )
    ])
    error_message = "The attribute netmask_length can't be set when using a static CIDR, you must define the netmask as part of cidr_block."
  }

  validation {
    condition = length(var.network) == 0 ? true : alltrue([
      for network in var.network : (
        !(network.ipam_pool_id != null && network.netmask_length == null)
      )
    ])
    error_message = "The attribute netmask_length is required when using IPAM Pool ID."
  }
}

variable "encryption" {
  description = "Databricks encryption keys"

  type = list(
    object({
      name      = string
      use_cases = list(string)
    })
  )
}

variable "config" {
  description = "Databricks Accelerator configuration"

  type = object({
    number_of_azs      = optional(number, 3)
    single_nat_gateway = optional(bool, false)
    enable_auto_prefix = optional(bool, true)
    enable_auto_suffix = optional(bool, true)
    create_groups      = optional(bool, true)
    network_acls = optional(object({
      public = optional(object({
        inbound = optional(list(object({
          protocol   = optional(string, "tcp")
          port       = number
          to_port    = optional(number)
          icmp_type  = optional(number)
          cidr_block = optional(string, "0.0.0.0/0")
        })), [])
        outbound = optional(list(object({
          protocol   = optional(string, "tcp")
          port       = number
          to_port    = optional(number)
          icmp_type  = optional(number)
          cidr_block = optional(string, "0.0.0.0/0")
        })), [])
      }))
      private = optional(object({
        inbound = optional(list(object({
          protocol   = optional(string, "tcp")
          port       = number
          to_port    = optional(number)
          icmp_type  = optional(number)
          cidr_block = optional(string, "0.0.0.0/0")
        })), [])
        outbound = optional(list(object({
          protocol   = optional(string, "tcp")
          port       = number
          to_port    = optional(number)
          icmp_type  = optional(number)
          cidr_block = optional(string, "0.0.0.0/0")
        })), [])
      }))
    }))
  })

  validation {
    condition     = var.config.number_of_azs >= 2 && var.config.number_of_azs <= 3
    error_message = "The number_of_azs must be in between 2 and 3."
  }
}

variable "tags" {
  description = "AWS tags for monitoring"
  type        = map(string)
  default     = {}
}