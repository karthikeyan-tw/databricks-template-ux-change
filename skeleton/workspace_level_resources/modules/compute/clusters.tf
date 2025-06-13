data "databricks_spark_version" "latest_lts" {
  latest            = true
  long_term_support = true
}

locals {
  on_demand = { for item in var.clusters : item.name => {
    availability : "SPOT_WITH_FALLBACK",
    first_on_demand : item.on_demand.composition == "ALL" ? item.max_workers + 1 : item.on_demand.composition == "DRIVER_ONLY" ? 1 : 0
  } }
}

resource "databricks_cluster" "compute" {
  for_each       = { for item in var.clusters : item.name => item }
  cluster_name   = each.value.name
  spark_version  = each.value.spark_version == "LTS" ? data.databricks_spark_version.latest_lts.id : each.value.spark_version
  runtime_engine = each.value.photon ? "PHOTON" : "STANDARD"
  is_pinned      = true

  # Set instance type for Driver and Worker nodes
  driver_node_type_id = each.value.driver_instance_type
  node_type_id        = each.value.instance_type

  # Set isolation mode to `Shared` for Unity Catalog access.
  # In the Databricks UI, this has been recently been renamed Access Mode
  # and USER_ISOLATION has been renamed Shared, but use these terms here.
  data_security_mode = "USER_ISOLATION"

  autoscale {
    min_workers = each.value.min_workers
    max_workers = each.value.max_workers
  }

  autotermination_minutes = each.value.auto_terminate

  aws_attributes {
    instance_profile_arn   = databricks_instance_profile.compute[each.key].id
    first_on_demand        = local.on_demand[each.key].first_on_demand
    availability           = local.on_demand[each.key].availability
    spot_bid_price_percent = each.value.on_demand.bid_price_percentage
  }

  # Monitoring: CloudWatch
  dynamic "init_scripts" {
    for_each = var.monitoring.cloudwatch ? [1] : []

    content {
      workspace {
        destination = databricks_workspace_file.cw_agent[0].path
      }
    }
  }

  # Monitoring: Datadog
  dynamic "init_scripts" {
    for_each = var.monitoring.datadog ? [1] : []

    content {
      workspace {
        destination = databricks_workspace_file.datadog_agent[0].path
      }
    }
  }

  # Spark configuration
  spark_conf = each.value.spark_conf

  # Environment Variables
  spark_env_vars = merge({
    DD_API_KEY = var.monitoring.datadog ? databricks_secret.api_key[0].config_reference : null
    DD_ENV     = var.monitoring.datadog ? "${var.environment}-${var.workspace}-${var.region}" : null
  }, each.value.spark_env_vars)

  # Instance types different from i3.* need an EBS volume attached.
  # The attribute below configures EBS via "Autoscaling local storage".
  enable_elastic_disk = startswith(each.value.instance_type, "i3") ? false : true

  # Cluster tags (AWS EC2 tags)
  custom_tags = var.tags
}