terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Using a recent version constraint
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.53.0" # Using a recent version constraint for Databricks provider
    }
    time = {
      source  = "hashicorp/time"
      version = "0.10.0"
    }
  }
}

provider "aws" {
  region = local.aws.region
}

provider "databricks" {
   host       = "https://accounts.cloud.databricks.com"
   account_id = local.databricks.account_id
}
