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

variable "security_profile" {
  description = "Databricks compliance security profiles"

  type = object({
    enabled              = optional(bool, false)
    compliance_standards = optional(set(string))
  })
}

variable "groups" {
  description = "Databricks groups and entitlements"

  type = list(
    object({
      name = string
      entitlements = optional(object({
        allow_cluster_create       = optional(bool, false)
        allow_instance_pool_create = optional(bool, false)
        databricks_sql_access      = optional(bool, false)
        workspace_access           = optional(bool, false)
      }))
    })
  )
}

variable "acl_compute_policy" {
  description = "Databricks Workspace ACLs: Compute Policy"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  }))
}

variable "acl_compute" {
  description = "Databricks Workspace ACLs: Compute Cluster"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  }))
}

variable "acl_sql_warehouse" {
  description = "Databricks Workspace ACLs: SQL Warehouse"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  }))
}

variable "acl_job" {
  description = "Databricks Workspace ACLs: Job"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  }))
}

variable "acl_dlt" {
  description = "Databricks Workspace ACLs: Delta Live Tables (DLT)"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  }))
}

variable "acl_secret" {
  description = "Databricks Workspace ACLs: Secret"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  }))

  validation {
    # Additional validation since TF provider doesn't check the permission
    condition = length(var.acl_secret) == 0 ? true : alltrue(flatten([
      for secret in var.acl_secret : [
        for group in secret.groups : (
          contains(["READ", "WRITE", "MANAGE"], group.permission)
        )
      ]
    ]))
    error_message = "The Secret ACL permission must be READ, WRITE or MANAGE"
  }
}

variable "acl_token" {
  description = "Databricks Workspace ACLs: Token"

  type = object({
    groups = optional(list(object({
      name       = string
      permission = string
    })))
  })
}

variable "uc_privilege_metastore" {
  description = "Databricks UC privileges: Metastore"

  type = object({
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  })
}

variable "uc_privilege_catalog" {
  description = "Databricks UC privileges: Catalog"

  type = list(object({
    catalog_name = string
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  }))
}

variable "uc_privilege_schema" {
  description = "Databricks UC privileges: Schema"

  type = list(object({
    catalog_name = string
    schema_name  = string
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  }))
}

variable "uc_privilege_table" {
  description = "Databricks UC privileges: Table"

  type = list(object({
    catalog_name = string
    schema_name  = string
    table_name   = string
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  }))
}

variable "uc_privilege_view" {
  description = "Databricks UC privileges: View"

  type = list(object({
    catalog_name = string
    schema_name  = string
    view_name    = string
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  }))
}

variable "uc_privilege_volume" {
  description = "Databricks UC privileges: Volume"

  type = list(object({
    catalog_name = string
    schema_name  = string
    volume_name  = string
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  }))
}

variable "uc_privilege_location" {
  description = "Databricks UC privileges: External Location"

  type = list(object({
    name = string
    groups = optional(list(object({
      name       = string
      privileges = list(string)
    })))
  }))
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "deployment_name_prefix" {
  description = "Prefix for deployment names"
  type        = string
  default     = ""
}