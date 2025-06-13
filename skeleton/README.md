# Databricks Accelerator

- [Databricks Accelerator](#databricks-accelerator)
- [Architecture](#architecture)
- [Product design and features](#product-design-and-features)
  - [Module #1: Databricks workspaces](#module-1-databricks-workspaces)
    - [Private connectivity using AWS PrivateLink](#private-connectivity-using-aws-privatelink)
    - [Customer-managed encryption keys](#customer-managed-encryption-keys)
  - [Module #2: Databricks compute clusters](#module-2-databricks-compute-clusters)
  - [Module #3: Databricks metastores](#module-3-databricks-metastores)
  - [Module #4: Databricks catalogs](#module-4-databricks-catalogs)
  - [Module #5: Databricks security](#module-5-databricks-security)
- [Product installation](#product-installation)
- [Product configuration](#product-configuration)
  - [Environments](#environments)
  - [Resources](#resources)
- [CI/CD pipelines](#cicd-pipelines)
- [Contributing to the project](#contributing-to-the-project)
  - [Project, backlog and issues](#project-backlog-and-issues)

The Databricks Accelerator for AWS introduces a cutting-edge solution designed to simplify and automate the management of **Databricks** and **Amazon Web Services (AWS)** resources. Powered by Terraform and DevOps principles, Databricks Accelerator introduces a low-code, YAML-based approach that enables teams to streamline CI/CD pipelines and significantly reduce manual intervention.

The solution automates key areas of Databricks, including account and workspace setup, AWS cloud resources (such as S3, IAM, VPC and KMS), Unity Catalog, compute clusters, SQL warehouses, and access control through user groups, access control lists (ACLs) and Unity Catalog privileges.

# Architecture

Databricks is structured to enable secure cross-functional team collaboration while keeping a significant amount of backend services managed by Databricks.

The solution operates out of a **control plane** and a **data plane** accounts:

- **Control plane**: Databricks internal AWS account containing the backend services such as web frontend application (Databricks UI console), REST APIs and resources configuration such as workspaces, users & cloud resources.
- **Data plane**: Customer's AWS account containing the data and backbone services such as S3 buckets, EC2, KMS keys and VPCs.

The diagram below demonstrates some of the resources expected in each cloud provider. For more information, review [Databricks architecture overview](https://docs.databricks.com/en/getting-started/overview.html).

![Databricks archictecture](.images/architecture_high_level.png)

# Product design and features

The Databricks Accelerator supports infrastructure-as-code (IaC) automation for different types of resources available as part of [Databricks E2 platform](https://docs.databricks.com/en/getting-started/overview.html). The product is powered by Terraform, DevOps principles and a low-code, YAML-based approach to configure the resources and deployments.

![Product engine](.images/product_engine.png)

This repository contains implementation examples, documentation and links to the respective Terraform modules:

1. `workspace`: Databricks workspaces + cloud resources (IAM, S3, VPC and KMS).
2. `compute`: Databricks compute clusters + monitoring with Amazon CloudWatch / Datadog.
3. `metastore`: Databricks metastores (Unity Catalog).
4. `catalog`: Databricks catalogs, schemas and external locations.
5. `security`: Databricks groups and permissions via access control lists (ACLs) and Unity Catalog privileges.

## Module #1: Databricks workspaces

Databricks workspaces & cloud resources are automated and supported by the Databricks Accelerator.

Although architectures may vary depending on custom configurations, the following diagram represents the entities and relationship between all services that can be deployed on Databricks and AWS.

![Databricks archictecture](.images/architecture_detail.png)

While **credentials** and **storage** configurations are mandatory, other resources such as **metastore**, **networks**, **vpc endpoints** and **encryption keys** can be selected based on different customer requirements. All the services described above are currently supported by the Terraform module [**Databricks Workspaces**](./examples/workspace/README.md) and they can be fully customised based on different customer requirements.

To demonstrate the flexibility of this product, we describe a couple of advanced configuration scenarios with private network traffic and custom encryption keys in the sections below.

### Private connectivity using AWS PrivateLink

By default, a **Databricks-managed VPC** is created automatically by Databricks control plane during the provisioning of a new workspace, the VPC is deployed with a NAT Gateway as part of the private subnets to allow external connectivity via public internet.

If a customer has a sensitive requirement in which the communication between Databricks control plane and AWS data plane shouldn't leave the AWS private network, it is possible to create a **Customer-managed VPC** and implement a set of **VPC endpoints + AWS Private Link** to connect Databricks and AWS accounts via private network traffic.

This feature is already part of the existing Terraform module and can be configured based on demand.

### Customer-managed encryption keys

By default, encryption keys are not enforced by Databricks but can be configured based on security & compliance requirements.

All the S3 buckets provisioned by this product are encrypted by default but in case a more robust encryption strategy is required, it is possible to create customer KMS keys and associate to Databricks in two different use cases:

- `MANAGED_SERVICES`: Databricks notebooks, secrets, etc
- `STORAGE`: DBFS (Databricks file system)

This feature is already part of the existing Terraform module and can be configured based on demand.

For more information about the encryption use cases, review [Customer-managed keys for encryption](https://docs.databricks.com/en/security/keys/customer-managed-keys.html).

## Module #2: Databricks compute clusters

Compute clusters are automated and supported by the Databricks Accelerator.

Advanced observability of **EC2** and **Apache Spark** metrics are available via integration with [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) and/or [Datadog](https://www.datadoghq.com/). The integration scenarios can be enabled / disabled via YAML configuration.

For more information about the Terraform module review [**Databricks Compute**](./examples/compute/README.md).

## Module #3: Databricks metastores

Metastore (Unity Catalog) is automated and supported by the Databricks Accelerator.

Currently, Databricks restricts the deployment of a single Databricks Unity Catalog per region, the product follows this constraint but it allows the association of one to many [1..N] Databricks workspaces for the same metastore.

For more information about the Terraform module review [**Databricks Metastore**](./examples/metastore/README.md).

## Module #4: Databricks catalogs

Catalogs and schemas are automated and supported by the Databricks Accelerator, the resources are created as part of a single Databricks Unity Catalog (a.k.a. metastore) but they are associated to specific Databricks workspaces.

Due to the current restriction of single metastore per region, we make use of catalogs to separate the technical environments (e.g. development, staging, production) and isolate data across different S3 buckets and AWS accounts.

The latest recommendation of Databricks, since Q4/2023 is to create the metastore without the storage root and associate separate buckets in the catalog level. The diagram below demonstrates the recommended configuration and the approach taken as part of this product.

![Databricks metastores and catalogs](.images/metastore_catalog.png)

For more information about the Terraform module review [**Databricks Catalog**](./examples/catalog/README.md).

## Module #5: Databricks security

Groups, Access Control Lists (ACLs) and UC privileges are automated and supported by the Databricks Accelerator.

Deploy one to many [1..N] groups and associate them with one to many [1..N] ACLs (e.g. compute clusters, SQL warehouses) and one to many [1..N] Unity Catalog privileges (e.g. catalogs, schemas, tables, views).

This module provides additional support for customers that have a BAA agreement with Databricks and want to enhance the security features by enabling the [compliance security profile](https://docs.databricks.com/en/security/privacy/security-profile.html).

For more information about the Terraform module review [**Databricks Security**](./examples/security/README.md).

# Product installation

The product setup requires many steps that are documented as part of the [Installation and setup guide](./installation/README.md).

Some of the main areas are described by the table of contents such as:

* Pre-requisites
* Customer on-boarding checklist and questionnaire
* Installation steps

# Product configuration

The modules are fully configurable and can be tailored based on YAML files configured as part of the Terraform projects.

These files are stored in the following folder structure:

```
config/
  environments.yml
  resources/
    default.yml
    template1.yml
    template2.yml
```

Terraform resources can be customized in different ways by splitting or combining templates while assigning them to different **environments** (e.g. sandbox, test, production) and **regions** (e.g. Sydney and Oregon).

The diagram below shows an example of how different environments and resources can be correlated based on the YAML configuration. 

![Environments and resources](.images/workspaces.png)

## Environments

The `environments.yml` is responsible for the setup of [Terraform workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) and basic configuration such as environment name, cloud region and a list of resource templates (optional).

An unlimited number of environments can be configured and the only constraint is the environment key must be defined as a unique value. We advise to combine the environment name, cloud provider and region to generate this unique key (e.g. `<environment>-<provider>-<region>`).

## Resources

The `resources` folder contains one or more templates with resources supported by the Terraform module defined in `main.tf`.

The minimum requirement is to have at least one YAML file named as `default.yml` but other files can be named as desired, including adding subfolders with other templates. An example structure with subfolders is available below:

```
config/
  resources/
    topics/
      template1.yml
      template2.yml
    schemas/
      template3.yml
    environment/
      sandbox/
        template4.yml
    default.yml
```

The environment and resources configuration of each module is described in more detail in the following documents:

* [Databricks Workspaces | YAML configuration](./examples/workspace/README.md)
* [Databricks Metastore | YAML configuration](./examples/metastore/README.md)
* [Databricks Catalog | YAML configuration](./examples/catalog/README.md)
* [Databricks Compute | YAML configuration](./examples/compute/README.md)
* [Databricks Security | YAML configuration](./examples/security/README.md)

# CI/CD pipelines

Examples of CI/CD pipelines based on **Github Actions** are available in the `.github/workflows` folder.

The modules have CI/CD pipelines configured based on workflow dispatch but the samples can be completely refactored based on demand. Both examples follow the workflow described by the diagram below.

![Github Actions](.images/pipelines.png)

For more information, check our [CI/CD pipelines](./.github/GITHUB_ACTIONS.md) development guide.

# Contributing to the project

If you are interested in developing new features or helping with bug fixes feel free to review our [Contribution guidelines](./CONTRIBUTING.md).

## Project, backlog and issues

A new project was created with the objective of tracking the following activities:

* Features
* Bug reports
* Chores (e.g. documentation, code clean-up, etc)

For more information visit:
* [Databricks accelerator | Project board](https://github.com/orgs/itoc/projects/6)
* [Databricks accelerator | Issues](https://github.com/itoc/databricks-tf-accelerator/issues)