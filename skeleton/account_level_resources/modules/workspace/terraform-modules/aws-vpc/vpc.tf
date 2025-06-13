################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block          = var.cidr
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge({
    Name = var.name
  }, var.tags)
}