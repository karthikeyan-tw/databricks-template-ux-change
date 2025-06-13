# Databricks workspaces | Terraform module

Terraform module for **Databricks workspaces**.

For more details about this module and its usage, refer to the official documentation at **[Databricks accelerator](https://github.com/itoc/databricks-tf-accelerator)**.

## Supported resources

#### Databricks
* Workspaces
* Cloud resources
    * Credentials
    * Storage
    * Network
    * Encryption

#### AWS
* IAM
* S3
* VPC
* KMS

# Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.53.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.53.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.53.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./terraform-modules/aws-vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cross_account](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_pass_role](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.cross_account](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cross_account](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_pass_role](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.customer_key](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.customer_key](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/kms_key) | resource |
| [aws_network_acl_rule.vpc_private_outbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.vpc_public_inbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.vpc_public_outbound](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/network_acl_rule) | resource |
| [aws_s3_bucket.root_storage](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.root_storage](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.root_storage](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.root_storage](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.root_storage](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.private_link](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.kinesis](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.relay](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sts](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.workspace](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/resources/vpc_endpoint) | resource |
| [databricks_group.workspace_admin](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/group) | resource |
| [databricks_group.workspace_user](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/group) | resource |
| [databricks_metastore_assignment.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/metastore_assignment) | resource |
| [databricks_mws_credentials.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_credentials) | resource |
| [databricks_mws_customer_managed_keys.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_customer_managed_keys) | resource |
| [databricks_mws_networks.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_networks) | resource |
| [databricks_mws_permission_assignment.workspace_admin](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_permission_assignment.workspace_user](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_private_access_settings.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_private_access_settings) | resource |
| [databricks_mws_storage_configurations.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_storage_configurations) | resource |
| [databricks_mws_vpc_endpoint.relay](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_vpc_endpoint) | resource |
| [databricks_mws_vpc_endpoint.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_vpc_endpoint) | resource |
| [databricks_mws_workspaces.workspace](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/resources/mws_workspaces) | resource |
| [time_sleep.wait](https://registry.terraform.io/providers/hashicorp/time/0.10.0/docs/resources/sleep) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iam_pass_role](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/5.53.0/docs/data-sources/iam_policy_document) | data source |
| [databricks_aws_assume_role_policy.trust_policy](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/data-sources/aws_assume_role_policy) | data source |
| [databricks_aws_crossaccount_policy.cross_account](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/data-sources/aws_crossaccount_policy) | data source |
| [databricks_metastores.all](https://registry.terraform.io/providers/databricks/databricks/1.53.0/docs/data-sources/metastores) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks account ID | `string` | n/a | yes |
| <a name="input_config"></a> [config](#input\_config) | Databricks Accelerator configuration | <pre>object({<br/>    number_of_azs      = optional(number, 3)<br/>    single_nat_gateway = optional(bool, false)<br/>    enable_auto_prefix = optional(bool, true)<br/>    enable_auto_suffix = optional(bool, true)<br/>    create_groups      = optional(bool, true)<br/>    network_acls = optional(object({<br/>      public = optional(object({<br/>        inbound = optional(list(object({<br/>          protocol   = optional(string, "tcp")<br/>          port       = number<br/>          to_port    = optional(number)<br/>          icmp_type  = optional(number)<br/>          cidr_block = optional(string, "0.0.0.0/0")<br/>        })), [])<br/>        outbound = optional(list(object({<br/>          protocol   = optional(string, "tcp")<br/>          port       = number<br/>          to_port    = optional(number)<br/>          icmp_type  = optional(number)<br/>          cidr_block = optional(string, "0.0.0.0/0")<br/>        })), [])<br/>      }))<br/>      private = optional(object({<br/>        inbound = optional(list(object({<br/>          protocol   = optional(string, "tcp")<br/>          port       = number<br/>          to_port    = optional(number)<br/>          icmp_type  = optional(number)<br/>          cidr_block = optional(string, "0.0.0.0/0")<br/>        })), [])<br/>        outbound = optional(list(object({<br/>          protocol   = optional(string, "tcp")<br/>          port       = number<br/>          to_port    = optional(number)<br/>          icmp_type  = optional(number)<br/>          cidr_block = optional(string, "0.0.0.0/0")<br/>        })), [])<br/>      }))<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_credential"></a> [credential](#input\_credential) | Databricks credential | <pre>object({<br/>    policy = optional(string, "managed")<br/>  })</pre> | n/a | yes |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | Databricks encryption keys | <pre>list(<br/>    object({<br/>      name      = string<br/>      use_cases = list(string)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Databricks environment name | `string` | n/a | yes |
| <a name="input_metastore"></a> [metastore](#input\_metastore) | Databricks metastore name | `string` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | Databricks network | <pre>list(<br/>    object({<br/>      name             = string<br/>      cidr_block       = optional(string, null)<br/>      ipam_pool_id     = optional(string, null)<br/>      netmask_length   = optional(number, null)<br/>      internet_gateway = optional(bool, false)<br/>      nat_gateway      = optional(bool, false)<br/>      private_link     = optional(bool, false)<br/>      vpc_flow_logs    = optional(bool, false)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_storage"></a> [storage](#input\_storage) | Databricks storage | <pre>list(<br/>    object({<br/>      name          = string<br/>      s3_prefix     = optional(string)<br/>      s3_versioning = optional(bool, false)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS tags for monitoring | `map(string)` | `{}` | no |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | Databricks workspaces | <pre>list(<br/>    object({<br/>      name           = string<br/>      storage        = string<br/>      network        = optional(string)<br/>      private_access = optional(bool, false)<br/>      encryption = optional(object({<br/>        managed_services = optional(string)<br/>        storage          = optional(string)<br/>      }))<br/>    })<br/>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3"></a> [s3](#output\_s3) | Databricks S3 storage |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Databricks customer-managed VPCs |
<!-- END_TF_DOCS -->