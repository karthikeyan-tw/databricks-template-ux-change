terraform {
  # required_version = ">= 1.4.5, <= 1.5.5"
  required_version = "~> 1.11"

  backend "s3" {
    # The bucket and region will be configured via -backend-config in GitHub Actions
    encrypt = true
  }
}


