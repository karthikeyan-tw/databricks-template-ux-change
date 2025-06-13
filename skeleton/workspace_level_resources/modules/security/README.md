# Databricks security | Terraform module

Terraform module for **Databricks security**.

For more details about this module and its usage, refer to the official documentation at **[Databricks accelerator](https://github.com/itoc/databricks-tf-accelerator)**.

## Supported resources

#### Databricks

* Compliance Security Profiles
    * HIPAA
    * PCI-DSS
* Groups
    * Workspace entitlements
    * Access Control Lists (ACLs)
        * Compute clusters
        * SQL warehouses

# Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.52.0 |
| <a name="provider_databricks.accounts"></a> [databricks.accounts](#provider\_databricks.accounts) | 1.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_compliance_security_profile_workspace_setting.compliance](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/compliance_security_profile_workspace_setting) | resource |
| [databricks_enhanced_security_monitoring_workspace_setting.compliance](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/enhanced_security_monitoring_workspace_setting) | resource |
| [databricks_entitlements.custom](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/entitlements) | resource |
| [databricks_grant.catalog](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_grant.external_location](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_grant.metastore](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_grant.schema](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_grant.table](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_grant.view](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_grant.volume](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/grant) | resource |
| [databricks_group.custom](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/group) | resource |
| [databricks_permission_assignment.custom](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permission_assignment) | resource |
| [databricks_permissions.compute](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permissions) | resource |
| [databricks_permissions.compute_policy](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permissions) | resource |
| [databricks_permissions.dlt](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permissions) | resource |
| [databricks_permissions.job](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permissions) | resource |
| [databricks_permissions.sql_warehouse](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permissions) | resource |
| [databricks_permissions.token](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/permissions) | resource |
| [databricks_secret_acl.scope](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/resources/secret_acl) | resource |
| [databricks_catalog.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/catalog) | data source |
| [databricks_cluster.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/cluster) | data source |
| [databricks_cluster_policy.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/cluster_policy) | data source |
| [databricks_current_metastore.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/current_metastore) | data source |
| [databricks_external_location.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/external_location) | data source |
| [databricks_job.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/job) | data source |
| [databricks_pipelines.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/pipelines) | data source |
| [databricks_schema.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/schema) | data source |
| [databricks_sql_warehouse.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/sql_warehouse) | data source |
| [databricks_table.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/table) | data source |
| [databricks_views.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/views) | data source |
| [databricks_volume.existing](https://registry.terraform.io/providers/databricks/databricks/1.52.0/docs/data-sources/volume) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks account ID | `string` | n/a | yes |
| <a name="input_acl_compute"></a> [acl\_compute](#input\_acl\_compute) | Databricks Workspace ACLs: Compute Cluster | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_acl_compute_policy"></a> [acl\_compute\_policy](#input\_acl\_compute\_policy) | Databricks Workspace ACLs: Compute Policy | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_acl_dlt"></a> [acl\_dlt](#input\_acl\_dlt) | Databricks Workspace ACLs: Delta Live Tables (DLT) | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_acl_job"></a> [acl\_job](#input\_acl\_job) | Databricks Workspace ACLs: Job | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_acl_secret"></a> [acl\_secret](#input\_acl\_secret) | Databricks Workspace ACLs: Secret | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_acl_sql_warehouse"></a> [acl\_sql\_warehouse](#input\_acl\_sql\_warehouse) | Databricks Workspace ACLs: SQL Warehouse | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_acl_token"></a> [acl\_token](#input\_acl\_token) | Databricks Workspace ACLs: Token | <pre>object({<br/>    groups = optional(list(object({<br/>      name       = string<br/>      permission = string<br/>    })))<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Databricks environment name | `string` | n/a | yes |
| <a name="input_groups"></a> [groups](#input\_groups) | Databricks groups and entitlements | <pre>list(<br/>    object({<br/>      name = string<br/>      entitlements = optional(object({<br/>        allow_cluster_create       = optional(bool, false)<br/>        allow_instance_pool_create = optional(bool, false)<br/>        databricks_sql_access      = optional(bool, false)<br/>        workspace_access           = optional(bool, false)<br/>      }))<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_security_profile"></a> [security\_profile](#input\_security\_profile) | Databricks compliance security profiles | <pre>object({<br/>    enabled              = optional(bool, false)<br/>    compliance_standards = optional(set(string))<br/>  })</pre> | n/a | yes |
| <a name="input_uc_privilege_catalog"></a> [uc\_privilege\_catalog](#input\_uc\_privilege\_catalog) | Databricks UC privileges: Catalog | <pre>list(object({<br/>    catalog_name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_uc_privilege_location"></a> [uc\_privilege\_location](#input\_uc\_privilege\_location) | Databricks UC privileges: External Location | <pre>list(object({<br/>    name = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_uc_privilege_metastore"></a> [uc\_privilege\_metastore](#input\_uc\_privilege\_metastore) | Databricks UC privileges: Metastore | <pre>object({<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  })</pre> | n/a | yes |
| <a name="input_uc_privilege_schema"></a> [uc\_privilege\_schema](#input\_uc\_privilege\_schema) | Databricks UC privileges: Schema | <pre>list(object({<br/>    catalog_name = string<br/>    schema_name  = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_uc_privilege_table"></a> [uc\_privilege\_table](#input\_uc\_privilege\_table) | Databricks UC privileges: Table | <pre>list(object({<br/>    catalog_name = string<br/>    schema_name  = string<br/>    table_name   = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_uc_privilege_view"></a> [uc\_privilege\_view](#input\_uc\_privilege\_view) | Databricks UC privileges: View | <pre>list(object({<br/>    catalog_name = string<br/>    schema_name  = string<br/>    view_name    = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_uc_privilege_volume"></a> [uc\_privilege\_volume](#input\_uc\_privilege\_volume) | Databricks UC privileges: Volume | <pre>list(object({<br/>    catalog_name = string<br/>    schema_name  = string<br/>    volume_name  = string<br/>    groups = optional(list(object({<br/>      name       = string<br/>      privileges = list(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_workspace"></a> [workspace](#input\_workspace) | Databricks workspace name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->