
terraform {
  required_version = ">= 1.4.5"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.53.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

locals {
  selected_workspace = one([
    for ws in local.resources.workspaces : ws
    if ws.name == var.workspace_name
  ])
}

provider "aws" {
  region = local.aws.region
}

provider "databricks" {
  alias      = "accounts"
  host       = "https://accounts.cloud.databricks.com"
  account_id = local.databricks.account_id
}

provider "databricks" {
  host = "https://${local.environment.deployment_name_prefix}-${local.environment.name}-${local.selected_workspace.name}-${local.aws.region}.cloud.databricks.com"
}

module "databricks_catalog" {
  source = "./modules/catalog"
  providers = {
    databricks = databricks
    databricks.accounts = databricks.accounts
  }
  # Environment configuration
  environment = local.environment.name
  account_id  = local.databricks.account_id
  workspace   = local.selected_workspace.name
  region      = local.aws.region
  deployment_name_prefix = local.environment.deployment_name_prefix
  
  # Resources
  catalogs           = local.selected_workspace.catalogs
  external_locations = local.selected_workspace.external_locations

  # Global configuration
  config = local.config

  # AWS tags
  tags = local.tags

}

module "databricks_compute" {
  source = "./modules/compute"

  providers = {
    databricks= databricks
    databricks.accounts = databricks.accounts
  }

  # Environment configuration
  environment = local.environment.name
  account_id  = local.databricks.account_id
  workspace   = local.selected_workspace.name
  region      = local.aws.region
  deployment_name_prefix = local.environment.deployment_name_prefix
  
  # Resources
  clusters       = local.selected_workspace.clusters
  sql_warehouses = local.selected_workspace.sql_warehouses
  monitoring     = local.selected_workspace.monitoring

  # From TF_VAR_* (environment variables)
  datadog_api_key = var.datadog_api_key

  # Global configuration
  config = local.config

  # AWS tags
  tags = local.tags
}

module "databricks_security" {
  source = "./modules/security"

  providers = {
    databricks= databricks
    databricks.accounts = databricks.accounts
    aws        = aws
  }

  # Databricks configuration
  environment = local.environment.name
  account_id  = local.databricks.account_id
  workspace   = local.selected_workspace.name
  region      = local.aws.region
  deployment_name_prefix = local.environment.deployment_name_prefix

  # Resources
  security_profile = local.selected_workspace.security_profile
  groups           = local.resources.groups

  # Resources: Workspace ACLs
  acl_compute_policy = local.selected_workspace.acls.compute_policy
  acl_compute        = local.selected_workspace.acls.compute
  acl_sql_warehouse  = local.selected_workspace.acls.sql_warehouse
  acl_job            = local.selected_workspace.acls.job
  acl_dlt            = local.selected_workspace.acls.delta_live_tables
  acl_secret         = local.selected_workspace.acls.secret_scope
  acl_token          = local.selected_workspace.acls.token

  # Resources: Unity Catalog privileges
  uc_privilege_metastore = local.selected_workspace.uc_privileges.metastore
  uc_privilege_catalog   = local.selected_workspace.uc_privileges.catalog
  uc_privilege_schema    = local.selected_workspace.uc_privileges.schema
  uc_privilege_table     = local.selected_workspace.uc_privileges.table
  uc_privilege_view      = local.selected_workspace.uc_privileges.view
  uc_privilege_volume    = local.selected_workspace.uc_privileges.volume
  uc_privilege_location  = local.selected_workspace.uc_privileges.external_location

  depends_on = [
    module.databricks_catalog,
    module.databricks_compute
  ]
}