# Databricks compute | Terraform module

Terraform module for **Databricks compute** clusters.

For more details about this module and its usage, refer to the official documentation at **[Databricks accelerator](https://github.com/itoc/databricks-tf-accelerator)**.

## Supported resources

#### Databricks
* Compute clusters
* SQL endpoints (future state)

#### AWS
* EC2
* IAM
* CloudWatch

#### Datadog
* Datadog agent

# Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.27.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.5.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.27.0 |
| <a name="provider_databricks.accounts"></a> [databricks.accounts](#provider\_databricks.accounts) | 1.27.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.compute](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.describe_tags](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.compute](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cw_agent](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.describe_tags](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/resources/iam_role_policy_attachment) | resource |
| [databricks_cluster.compute](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/cluster) | resource |
| [databricks_group.compute_admin](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group) | resource |
| [databricks_group.compute_user](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group) | resource |
| [databricks_group.sql_warehouse_admin](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group) | resource |
| [databricks_group.sql_warehouse_user](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/group) | resource |
| [databricks_instance_profile.compute](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/instance_profile) | resource |
| [databricks_permission_assignment.compute_admin](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permission_assignment) | resource |
| [databricks_permission_assignment.compute_user](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permission_assignment) | resource |
| [databricks_permission_assignment.sql_warehouse_admin](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permission_assignment) | resource |
| [databricks_permission_assignment.sql_warehouse_user](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permission_assignment) | resource |
| [databricks_permissions.compute_acl](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permissions) | resource |
| [databricks_permissions.sql_warehouse_acl](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/permissions) | resource |
| [databricks_secret.api_key](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret) | resource |
| [databricks_secret_scope.datadog](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/secret_scope) | resource |
| [databricks_sql_endpoint.compute](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/sql_endpoint) | resource |
| [databricks_workspace_file.cw_agent](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/workspace_file) | resource |
| [databricks_workspace_file.datadog_agent](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/resources/workspace_file) | resource |
| [aws_iam_policy.cw_agent_server](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.describe_tags](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/5.5.0/docs/data-sources/iam_policy_document) | data source |
| [databricks_spark_version.latest_lts](https://registry.terraform.io/providers/databricks/databricks/1.27.0/docs/data-sources/spark_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks account ID | `string` | n/a | yes |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | Databricks clusters | <pre>list(<br/>    object({<br/>      name                 = string<br/>      spark_version        = optional(string, "LTS")<br/>      photon               = optional(bool, true)<br/>      driver_instance_type = optional(string, null)<br/>      instance_type        = optional(string, "m5.large")<br/>      min_workers          = optional(number, 1)<br/>      max_workers          = optional(number, 1)<br/>      auto_terminate       = optional(number, 20) # in minutes<br/>      spark_env_vars       = optional(map(string))<br/>      spark_conf           = optional(map(string))<br/>      on_demand = optional(object({<br/>        composition          = optional(string, "DRIVER_ONLY")<br/>        bid_price_percentage = optional(number, 100)<br/>      }))<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_config"></a> [config](#input\_config) | Databricks Accelerator configuration | <pre>object({<br/>    can_restart   = optional(bool, false)<br/>    create_groups = optional(bool, true)<br/>  })</pre> | n/a | yes |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Databricks environment name | `string` | n/a | yes |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Monitoring integration | <pre>object({<br/>    datadog    = optional(bool, false)<br/>    cloudwatch = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sql_warehouses"></a> [sql\_warehouses](#input\_sql\_warehouses) | Databricks SQL warehouses | <pre>list(<br/>    object({<br/>      name                 = string<br/>      size                 = optional(string, "2X-Small")<br/>      photon               = optional(bool, true)<br/>      serverless           = optional(bool, false)<br/>      min_clusters         = optional(number, 1)<br/>      max_clusters         = optional(number, 1)<br/>      auto_terminate       = optional(number, 20) # in minutes<br/>      spot_instance_policy = optional(string, "COST_OPTIMIZED")<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS tags for monitoring | `map(string)` | `{}` | no |
| <a name="input_workspace"></a> [workspace](#input\_workspace) | Databricks workspace name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->