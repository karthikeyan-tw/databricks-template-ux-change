locals {
  public_route_table_ids  = aws_route_table.public[*].id
  private_route_table_ids = aws_route_table.private[*].id
}

################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this.id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this.arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this.cidr_block, null)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this.default_security_group_id, null)
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = try(aws_vpc.this.default_network_acl_id, null)
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = try(aws_vpc.this.default_route_table_id, null)
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = try(aws_vpc.this.enable_dns_support, null)
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = try(aws_vpc.this.enable_dns_hostnames, null)
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = try(aws_vpc.this.main_route_table_id, null)
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(aws_vpc.this.owner_id, null)
}

################################################################################
# Internet Gateway
################################################################################

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}

################################################################################
# Publiс Subnets
################################################################################

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.public[*].cidr_block)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = local.public_route_table_ids
}

output "public_internet_gateway_route_id" {
  description = "ID of the internet gateway route"
  value       = try(aws_route.public_internet_gateway[0].id, null)
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = aws_route_table_association.public[*].id
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = try(aws_network_acl.public[0].id, null)
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = try(aws_network_acl.public[0].arn, null)
}

################################################################################
# Private Subnets
################################################################################

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.private[*].cidr_block)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = local.private_route_table_ids
}

output "private_nat_gateway_route_ids" {
  description = "List of IDs of the private nat gateway route"
  value       = aws_route.private_nat_gateway[*].id
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = aws_route_table_association.private[*].id
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = try(aws_network_acl.private[0].id, null)
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = try(aws_network_acl.private[0].arn, null)
}

################################################################################
# NAT Gateway
################################################################################

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat[*].id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = var.reuse_nat_ips ? var.external_nat_ips : aws_eip.nat[*].public_ip
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "natgw_interface_ids" {
  description = "List of Network Interface IDs assigned to NAT Gateways"
  value       = aws_nat_gateway.this[*].network_interface_id
}

################################################################################
# VPC Flow Log
################################################################################

output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = try(aws_flow_log.this[0].id, null)
}

output "vpc_flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = local.flow_log_destination_arn
}

output "vpc_flow_log_destination_type" {
  description = "The type of the destination for VPC Flow Logs"
  value       = var.flow_log_destination_type
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = local.flow_log_iam_role_arn
}

output "vpc_flow_log_deliver_cross_account_role" {
  description = "The ARN of the IAM role used when pushing logs cross account"
  value       = try(aws_flow_log.this[0].deliver_cross_account_role, null)
}

################################################################################
# Static values (arguments)
################################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}