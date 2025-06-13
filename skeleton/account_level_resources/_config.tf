locals {
  environment = yamldecode(file("${path.module}/../config/environments.yml"))

  databricks = {
    account_id     = local.environment.databricks.account_id
  }

  aws = local.environment.aws

  resources = {

    workspaces = flatten([
      for template in try(local.environment.templates, ["default"]) :
      try(yamldecode(file("${path.module}/../config/${template}.yml")).workspaces, [])
    ])
    
   
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