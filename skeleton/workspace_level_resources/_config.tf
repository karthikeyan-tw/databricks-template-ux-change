locals {

  environment = yamldecode(file("${path.module}/../config/environments.yml"))

  databricks = {
    account_id     = local.environment.databricks.account_id
    metastore_name = try(local.environment.databricks.metastore_name, null)
  }

  aws = local.environment.aws

  resources = {

     workspace_enabled = try(
      yamldecode(file("${path.module}/../config/default.yml")).workspace_enabled, 
      false
    )

    workspaces = flatten([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).workspaces, [])
    ])
     # Add the workspace_enabled flag here, right after workspaces
    # workspace_enabled = length(flatten([
    #   for template in try(local.environment.templates, ["default"]) :
    #   try(yamldecode(file("${path.module}/config/${template}.yml")).workspaces, [])
    # ])) > 0
   
    credential = merge([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).cloud_resources.credential, {})
    ]...) 
    network = flatten([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).cloud_resources.network, [])
    ])
    storage = flatten([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).cloud_resources.storage, [])
    ])

    groups = flatten([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).groups, [])
    ])

    metastore =  yamldecode(file("${path.module}/../config/default.yml")).metastore

    encryption = flatten([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).cloud_resources.encryption, [])
    ])
    
  } 

  config = merge([
    for template in try(local.environment.templates, ["default"]) :
    try(yamldecode(file("${path.module}/../config/${template}.yml")).config, {})
  ]...) # Expand the list into separate arguments

  tags = merge([
    for template in try(local.environment.templates, ["default"]) :
    try(yamldecode(file("${path.module}/../config/${template}.yml")).tags, {})
  ]...) # Expand the list into separate arguments
}