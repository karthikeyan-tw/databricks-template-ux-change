# Databricks external locations | Terraform module

This module supports the deployment of Databricks external locations and storage credentials.

# Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.47.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.53.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.47.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.permission](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.permission](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.location](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role) | resource |
| [aws_s3_bucket.location](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.location](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.location](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.location](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_versioning) | resource |
| [databricks_external_location.location](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/external_location) | resource |
| [databricks_storage_credential.location](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/storage_credential) | resource |
| [time_sleep.wait](https://registry.terraform.io/providers/hashicorp/time/0.10.0/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.permission](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trust](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/kms_key) | data source |
| [aws_s3_bucket.existing](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks account ID | `string` | n/a | yes |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Create or reuse existing S3 bucket? | `string` | `true` | no |
| <a name="input_external_location"></a> [external\_location](#input\_external\_location) | External location name | `string` | n/a | yes |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | IAM role name | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket name | `string` | n/a | yes |
| <a name="input_s3_kms_key"></a> [s3\_kms\_key](#input\_s3\_kms\_key) | S3 KMS encryption key | `string` | `null` | no |
| <a name="input_s3_versioning"></a> [s3\_versioning](#input\_s3\_versioning) | Enable S3 versioning? | `bool` | `false` | no |
| <a name="input_storage_credential"></a> [storage\_credential](#input\_storage\_credential) | Storage credential name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS tags for monitoring | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->