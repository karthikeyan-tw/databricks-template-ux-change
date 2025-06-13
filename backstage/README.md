# Databricks Terraform Accelerator - Backstage Template

## Overview
This Backstage template provides a simplified way to deploy Databricks infrastructure using predefined configuration templates. Users can select from preset configurations and provide minimal input to get started quickly.

## Key Features
- **Simplified User Experience**: Only 2 configuration options instead of 100+ parameters
- **Direct Configuration Loading**: Predefined YAML files are loaded directly
- **Quick Deployment**: Minimal user input required
- **Tested Configurations**: Each template is pre-tested and production-ready

## Configuration Templates

### 1. Default Configuration (`default.yaml`)
- **Use Case**: Production Thoughtworks setup
- **Features**: 
  - Complete workspace with development and demo catalogs
  - Shared cluster with m4.large instances
  - SQL warehouse with serverless support
  - Comprehensive ACLs and Unity Catalog privileges
  - Full job, DLT, and secret scope configurations

### 2. Alternate Configuration (`alternate.yaml`)
- **Use Case**: Analytics-focused variant
- **Features**:
  - Analytics workspace with different schema structure
  - Larger r5.large instances with Photon enabled
  - Medium-sized SQL warehouse
  - Simplified ACL structure
  - CloudWatch monitoring enabled

## User Input Required

### Step 1: Basic Configuration
- **Client Deployment Name**: Unique identifier for your deployment
- **Configuration Template**: Choose between Default or Alternate
- **Deployment Owner**: Owner of the deployment

### Step 2: CI/CD Configuration
- **Repository URL**: Target GitHub repository
- **AWS Details**: Region, OIDC Role ARN, S3 bucket names
- **Databricks Details**: Account ID, Client ID/Secret, Host URL

## How It Works

1. **User Selection**: User selects configuration template from dropdown
2. **Direct File Copy**: Selected configuration file is copied to `config/default.yml`
3. **Minimal Templating**: Only essential deployment details are templated
4. **Repository Creation**: Complete, working repository is created

## File Structure

```
backstage/
├── software_template.yaml           # Main template definition
├── configurations/                  # Configuration templates
│   ├── default.yaml                # Thoughtworks production setup
│   └── alternate.yaml              # Analytics variant
├── scaffolder/                      # Minimal templates
│   ├── config/
│   │   └── environments.yml.njk    # Environment configuration
│   └── backstage/
│       └── catalog-info.yaml.njk   # Backstage catalog metadata
└── README.md                        # This file
```

## Benefits

- **⚡ Fast**: 2-3 minutes to deploy vs 30+ minutes
- **🎯 Simple**: 10 essential inputs vs 100+ complex parameters
- **🔧 Reliable**: Pre-tested configurations reduce errors
- **📈 Scalable**: Easy to add new configuration variants
- **🔄 Maintainable**: Centralized configuration management

## Adding New Configurations

To add a new configuration variant:

1. Create a new YAML file in `backstage/configurations/`
2. Add the configuration name to the enum in `software_template.yaml`
3. Update the `enumNames` with a descriptive name
4. Test the configuration

## Technical Details

- **No Complex Parameter Mapping**: Configurations are copied directly
- **Minimal Scaffolding**: Only deployment-specific values are templated
- **Direct File Loading**: Uses `fetch:plain` action for configuration files
- **Environment Variables**: All necessary CI/CD variables are set automatically 