terraform {
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