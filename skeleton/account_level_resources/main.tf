module "databricks_metastore" {
  source = "./modules/metastore"

  # Environment configuration
  account_id = local.databricks.account_id
  region     = local.aws.region

  # Resources
  metastore = local.resources.metastore

  # AWS tags
  tags = local.tags
}

module "databricks_workspace" {
  source = "./modules/workspace"

  # Environment configuration
  environment = local.environment.name
  account_id  = local.databricks.account_id
  metastore   = "metastore-${local.aws.region}"
  region      = local.aws.region

  # Resources
  workspaces = local.resources.workspaces
  credential = local.resources.credential
  network    = local.resources.network
  storage    = local.resources.storage
  encryption = local.resources.encryption

  # Global configuration
  config = local.config

  # AWS tags
  tags = local.tags

  depends_on = [
    module.databricks_metastore
  ]
}