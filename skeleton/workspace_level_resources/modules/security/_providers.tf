terraform {
  required_version = ">= 1.4.5"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.53.0"
      configuration_aliases = [
        databricks.accounts
      ]
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}