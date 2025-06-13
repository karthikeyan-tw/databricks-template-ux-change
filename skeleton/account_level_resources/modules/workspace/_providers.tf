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
    time = {
      source  = "hashicorp/time"
      version = "0.10.0"
    }
  }
}

# provider "databricks" {
#   host       = "https://accounts.cloud.databricks.com"
#   account_id = var.account_id
# }

# provider "aws" {
#   region = var.region
# }