# Databricks catalog | Terraform module

Terraform module for **Databricks catalogs and schemas (unity catalog)**.

For more details about this module and its usage, refer to the official documentation at **[Databricks accelerator](https://github.com/itoc/databricks-tf-accelerator)**.

## Supported resources

#### Databricks
* Metastore
    * Workspace assignment
* Catalogs
* Schemas

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
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.47.0 |
| <a name="provider_databricks.accounts"></a> [databricks.accounts](#provider\_databricks.accounts) | 1.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_catalog"></a> [catalog](#module\_catalog) | ./terraform-modules/databricks-external-location | n/a |
| <a name="module_external_location"></a> [external\_location](#module\_external\_location) | ./terraform-modules/databricks-external-location | n/a |

## Resources

| Name | Type |
|------|------|
| [databricks_catalog.catalog](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/catalog) | resource |
| [databricks_grant.catalog_browse](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_grant.catalog_data_admin](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_grant.catalog_data_reader](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_grant.catalog_external_location_browse](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_grant.external_location_admin](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_grant.external_location_browse](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_grant.external_location_writer](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/grant) | resource |
| [databricks_group.data_admin](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/group) | resource |
| [databricks_group.data_reader](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/group) | resource |
| [databricks_group.external_location_admin](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/group) | resource |
| [databricks_group.external_location_writer](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/group) | resource |
| [databricks_permission_assignment.data_admin](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/permission_assignment) | resource |
| [databricks_permission_assignment.data_reader](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/permission_assignment) | resource |
| [databricks_permission_assignment.external_location_admin](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/permission_assignment) | resource |
| [databricks_permission_assignment.external_location_writer](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/permission_assignment) | resource |
| [databricks_schema.schema](https://registry.terraform.io/providers/databricks/databricks/1.47.0/docs/resources/schema) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks account ID | `string` | n/a | yes |
| <a name="input_catalogs"></a> [catalogs](#input\_catalogs) | Databricks catalogs | <pre>list(<br/>    object({<br/>      name   = string<br/>      prefix = optional(bool, true)<br/>      storage = object({<br/>        enabled       = optional(bool, true)<br/>        s3_prefix     = optional(string)<br/>        s3_versioning = optional(bool, false)<br/>      })<br/>      isolated = optional(bool, true)<br/>      visible  = optional(bool, true)<br/>      schemas  = optional(set(string))<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_config"></a> [config](#input\_config) | Databricks Accelerator configuration | <pre>object({<br/>    create_groups = optional(bool, true)<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Databricks environment name | `string` | n/a | yes |
| <a name="input_external_locations"></a> [external\_locations](#input\_external\_locations) | Databricks external locations | <pre>list(<br/>    object({<br/>      name = string<br/>      storage = object({<br/>        create_bucket = optional(bool, true)<br/>        s3_prefix     = optional(string)<br/>        s3_bucket     = optional(string)<br/>        s3_versioning = optional(bool, false)<br/>        s3_kms_key    = optional(string, null)<br/>      })<br/>      visible = optional(bool, true)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS tags for monitoring | `map(string)` | `{}` | no |
| <a name="input_workspace"></a> [workspace](#input\_workspace) | Databricks workspace name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_catalog"></a> [s3\_catalog](#output\_s3\_catalog) | Databricks S3 catalog |
| <a name="output_s3_external_location"></a> [s3\_external\_location](#output\_s3\_external\_location) | Databricks S3 external location |
<!-- END_TF_DOCS -->