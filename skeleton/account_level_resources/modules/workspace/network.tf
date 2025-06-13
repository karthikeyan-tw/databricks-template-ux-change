resource "databricks_mws_networks" "workspace" {
  for_each = { for item in var.network : item.name => item }

  account_id   = var.account_id
  network_name = "${local.prefix}${each.key}${local.suffix}"

  vpc_id     = module.vpc[each.key].vpc_id
  subnet_ids = module.vpc[each.key].private_subnets

  security_group_ids = [
    module.vpc[each.key].default_security_group_id
  ]

  dynamic "vpc_endpoints" {
    for_each = each.value.private_link ? [1] : []

    content {
      dataplane_relay = [databricks_mws_vpc_endpoint.relay[each.key].vpc_endpoint_id]
      rest_api        = [databricks_mws_vpc_endpoint.workspace[each.key].vpc_endpoint_id]
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  aws_prefix = "databricks-${var.environment}"
  azs        = slice(
    data.aws_availability_zones.available.names,
    0,
    min(length(data.aws_availability_zones.available.names), var.config.number_of_azs)
  )
}

################################################################################
# AWS Virtual Private Cloud (VPC)
################################################################################

module "vpc" {
  for_each = { for item in var.network : item.name => item }
  source   = "./terraform-modules/aws-vpc"

  # VPC
  name = "${local.aws_prefix}-${each.key}"

  # CIDR | Scenario 1: Static
  cidr = each.value.cidr_block

  # CIDR | Scenario 2: IP Address Manager (IPAM)
  ipv4_ipam_pool_id   = each.value.ipam_pool_id
  ipv4_netmask_length = each.value.netmask_length

  # Availability Zones (calculated based on TF module configuration)
  azs = local.azs

  # Subnets (calculated dynamically based on number of AZs)
  public_subnet_names  = [for zone in local.azs : "${local.aws_prefix}-${each.key}-public-${zone}"]
  private_subnet_names = [for zone in local.azs : "${local.aws_prefix}-${each.key}-private-${zone}"]

  # Public Network Acess Control Lists (NACLs)
  public_dedicated_network_acl = true
  public_inbound_acl_rules     = local.network_acls.public.inbound
  public_outbound_acl_rules    = local.network_acls.public.outbound

  # Private Network Acess Control Lists (NACLs)
  private_dedicated_network_acl = true
  private_inbound_acl_rules     = local.network_acls.private.inbound
  private_outbound_acl_rules    = local.network_acls.private.outbound

  # DNS hostnames
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Internet Gateway
  create_igw = each.value.internet_gateway

  # NAT Gateway
  enable_nat_gateway = each.value.nat_gateway
  single_nat_gateway = var.config.single_nat_gateway

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = each.value.vpc_flow_logs
  create_flow_log_cloudwatch_log_group = each.value.vpc_flow_logs
  create_flow_log_cloudwatch_iam_role  = each.value.vpc_flow_logs
  flow_log_max_aggregation_interval    = 60

  # AWS Tags
  tags = var.tags
}

################################################################################
# Additional Network ACL rules for VPC CIDR
################################################################################

resource "aws_network_acl_rule" "vpc_public_inbound" {
  for_each       = { for item in var.network : item.name => item }
  network_acl_id = module.vpc[each.key].public_network_acl_id

  egress      = false
  rule_number = 1
  rule_action = "allow"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_block  = module.vpc[each.key].vpc_cidr_block
}

resource "aws_network_acl_rule" "vpc_public_outbound" {
  for_each       = { for item in var.network : item.name => item }
  network_acl_id = module.vpc[each.key].public_network_acl_id

  egress      = true
  rule_number = 1
  rule_action = "allow"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_block  = module.vpc[each.key].vpc_cidr_block
}

resource "aws_network_acl_rule" "vpc_private_outbound" {
  for_each       = { for item in var.network : item.name => item }
  network_acl_id = module.vpc[each.key].private_network_acl_id

  egress      = true
  rule_number = 1
  rule_action = "allow"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_block  = module.vpc[each.key].vpc_cidr_block
}