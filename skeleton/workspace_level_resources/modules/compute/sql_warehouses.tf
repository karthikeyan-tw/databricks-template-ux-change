resource "databricks_sql_endpoint" "compute" {
  for_each         = { for item in var.sql_warehouses : item.name => item }
  name             = each.value.name
  cluster_size     = each.value.size
  min_num_clusters = each.value.min_clusters
  max_num_clusters = each.value.max_clusters
  auto_stop_mins   = each.value.auto_terminate

  # Enable / disable Photon runtime and Serverless compute
  enable_photon             = each.value.photon
  enable_serverless_compute = each.value.serverless

  # Spot instance policy
  # Cost optimized: uses spot instances at 100% bid price for all workers, 
  #  with auto-fallback to on-demand instances. If an instance is reclaimed,
  #  queries running on that instance will transfer to a new worker without
  #  any manual intervention or resubmission required.
  # Reliability optimized: uses on-demand instances for all workers.
  spot_instance_policy = each.value.spot_instance_policy

  # Custom tags
  tags {
    dynamic "custom_tags" {
      for_each = var.tags

      content {
        key   = custom_tags.key
        value = custom_tags.value
      }
    }
  }
}