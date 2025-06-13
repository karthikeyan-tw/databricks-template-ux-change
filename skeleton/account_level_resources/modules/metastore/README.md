# Databricks metastore | Terraform module

Terraform module for **Databricks metastore (unity catalog)**.

For more details about this module and its usage, refer to the official documentation at **[Databricks accelerator](https://github.com/itoc/databricks-tf-accelerator)**.

## Supported resources

#### Databricks
* Metastore
    * Storage
    * Data Access

#### AWS
* IAM
* S3

# Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.53.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.metastore_permission](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.metastore_permission](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.metastore](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role) | resource |
| [aws_s3_bucket.metastore](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.metastore](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.metastore](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.metastore](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_versioning) | resource |
| [databricks_metastore.metastore](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/metastore) | resource |
| [databricks_metastore_data_access.metastore](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/metastore_data_access) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.metastore_permission](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.metastore_trust](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks account ID | `string` | n/a | yes |
| <a name="input_metastore"></a> [metastore](#input\_metastore) | Databricks metastore configuration | <pre>object({<br/>    storage = object({<br/>      enabled       = optional(bool, false)<br/>      s3_prefix     = optional(string)<br/>      s3_versioning = optional(bool, false)<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS tags for monitoring | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3"></a> [s3](#output\_s3) | Databricks S3 metastore |
<!-- END_TF_DOCS -->