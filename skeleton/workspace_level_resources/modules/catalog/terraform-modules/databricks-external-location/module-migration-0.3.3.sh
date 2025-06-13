#!/bin/bash

# This script covers the terraform state transfer from existing
#  catalog resources to the new external locations TF module.
# The attribute $1 receives the `name` of the catalog
#  configured in the YAML files inside `config/resources`.

# Databricks External Location
terraform state mv \
  "module.databricks_catalog.databricks_external_location.catalog[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].databricks_external_location.location"

# AWS S3 bucket
terraform state mv \
  "module.databricks_catalog.aws_s3_bucket.catalog[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].aws_s3_bucket.location[0]"
terraform state mv \
  "module.databricks_catalog.aws_s3_bucket_versioning.catalog[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].aws_s3_bucket_versioning.location[0]"
terraform state mv \
  "module.databricks_catalog.aws_s3_bucket_server_side_encryption_configuration.catalog[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].aws_s3_bucket_server_side_encryption_configuration.location[0]"

# Databricks Storage Credential
terraform state mv \
  "module.databricks_catalog.databricks_storage_credential.catalog[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].databricks_storage_credential.location"

# AWS IAM role & policies
terraform state mv \
  "module.databricks_catalog.aws_iam_role.catalog[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].aws_iam_role.location"
terraform state mv \
  "module.databricks_catalog.aws_iam_policy.catalog_permission[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].aws_iam_policy.permission"
terraform state mv \
  "module.databricks_catalog.aws_iam_policy_attachment.catalog_permission[\"$1\"]" \
  "module.databricks_catalog.module.catalog[\"$1\"].aws_iam_policy_attachment.permission"