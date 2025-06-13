# Databricks Accelerator Template for Backstage

This repository contains a Backstage template for creating and deploying Databricks infrastructure using Terraform. The accelerator simplifies the provisioning of Databricks workspaces, compute resources, Unity Catalog, metastores, and security configurations on AWS.

## Project Structure

```
databricks-aws-accelerator/
├── backstage/
│   ├── software_template.yaml    # Main template definition
│   ├── parameters/               # Parameter files are here
│   └── config/                   # Configuration templates
├── skeleton/                     # Source code to be published
│   └── ...                       # Terraform modules and configurations
└── README.md                     # This file
```

## How It Works

1. **Template Configuration**: The `software_template.yaml` defines the Backstage template with parameters for different aspects of Databricks infrastructure.

2. **Parameter Collection**: When users run the template, they input values for workspaces, compute resources, Unity Catalog, etc. through Backstage's UI.

3. **Configuration Generation**: The template renders Nunjucks templates to create Terraform configurations based on user inputs.

4. **Repository Creation**: The template publishes the generated code to a GitHub repository, setting up necessary variables and secrets.

5. **Automated Deployment**: A GitHub Action is triggered to automatically create resources in AWS and Databricks using the generated Terraform code.

## Generated Resources

The template can configure:

- **Workspaces**: Databricks workspaces with networking and storage configurations
- **Compute Resources**: Clusters and SQL warehouses with customizable specifications
- **Unity Catalog**: Catalogs, schemas, and external locations
- **Security**: Access controls, group permissions, and compliance settings
- **Infrastructure**: AWS storage, networking, and encryption settings

## Configuration Templates

The `default.yml.njk` template generates configuration for:

- Workspace settings and storage integration
- Cluster configurations with instance types and Spark versions
- SQL warehouses with scaling policies
- Unity Catalog resources and permissions
- Security profiles and access control lists
- Monitoring integrations

## Usage

1. Navigate to your Backstage portal
2. Select "Create" from the sidebar
3. Choose "Databricks Terraform Accelerator" from the template list
4. Fill in the required parameters
5. Submit to generate and publish your Databricks infrastructure code

## Infrastructure as Code

The generated repository contains Terraform modules that:

1. Deploy Databricks workspaces in your AWS account
2. Configure Unity Catalog resources
3. Set up compute resources with the right specifications
4. Implement security controls and access policies
5. Enable monitoring and governance

## Development

To extend this template:

1. Update parameter files in the `parameters/` directory
2. Modify Nunjucks templates in the `config/` directory
3. Update the skeleton code in the `skeleton/` directory
4. Adjust the `software_template.yaml` to incorporate new parameters or steps

---

This template is designed to accelerate the deployment of Databricks infrastructure on AWS while following best practices for security, governance, and scalability.
