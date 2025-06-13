resource "databricks_mws_vpc_endpoint" "workspace" {
  for_each            = { for item in var.network : item.name => item if item.private_link }
  account_id          = var.account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.workspace[each.key].id
  vpc_endpoint_name   = "${local.prefix}${each.key}-workspace${local.suffix}"
  region              = var.region

  depends_on = [
    aws_vpc_endpoint.workspace,
    # Additional dependencies for `terraform destroy` below
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint.sts,
    aws_vpc_endpoint.kinesis
  ]
}

resource "databricks_mws_vpc_endpoint" "relay" {
  for_each            = { for item in var.network : item.name => item if item.private_link }
  account_id          = var.account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.relay[each.key].id
  vpc_endpoint_name   = "${local.prefix}${each.key}-relay${local.suffix}"
  region              = var.region

  depends_on = [
    aws_vpc_endpoint.relay,
    # Additional dependencies for `terraform destroy` below
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint.sts,
    aws_vpc_endpoint.kinesis
  ]
}

resource "aws_vpc_endpoint" "workspace" {
  for_each     = { for item in var.network : item.name => item if item.private_link }
  service_name = local.vpc_endpoints.workspace[var.region]

  vpc_id            = module.vpc[each.key].vpc_id
  subnet_ids        = module.vpc[each.key].private_subnets
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.private_link[each.key].id
  ]

  private_dns_enabled = true

  tags = merge({
    Name = "databricks-${var.environment}-${each.key}-workspace"
  }, var.tags)
}

resource "aws_vpc_endpoint" "relay" {
  for_each     = { for item in var.network : item.name => item if item.private_link }
  service_name = local.vpc_endpoints.relay[var.region]

  vpc_id            = module.vpc[each.key].vpc_id
  subnet_ids        = module.vpc[each.key].private_subnets
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.private_link[each.key].id
  ]

  private_dns_enabled = true

  tags = merge({
    Name = "databricks-${var.environment}-${each.key}-relay"
  }, var.tags)
}

resource "aws_vpc_endpoint" "s3" {
  for_each     = { for item in var.network : item.name => item }
  service_name = "com.amazonaws.${var.region}.s3"

  vpc_id          = module.vpc[each.key].vpc_id
  route_table_ids = module.vpc[each.key].private_route_table_ids

  tags = merge({
    Name = "databricks-${var.environment}-${each.key}-s3"
  }, var.tags)
}

resource "aws_vpc_endpoint" "sts" {
  for_each     = { for item in var.network : item.name => item if item.private_link }
  service_name = "com.amazonaws.${var.region}.sts"

  vpc_id            = module.vpc[each.key].vpc_id
  subnet_ids        = module.vpc[each.key].private_subnets
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.private_link[each.key].id
  ]

  private_dns_enabled = true

  tags = merge({
    Name = "databricks-${var.environment}-${each.key}-sts"
  }, var.tags)
}

resource "aws_vpc_endpoint" "kinesis" {
  for_each     = { for item in var.network : item.name => item if item.private_link }
  service_name = "com.amazonaws.${var.region}.kinesis-streams"

  vpc_id            = module.vpc[each.key].vpc_id
  subnet_ids        = module.vpc[each.key].private_subnets
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.private_link[each.key].id
  ]

  private_dns_enabled = true

  tags = merge({
    Name = "databricks-${var.environment}-${each.key}-kinesis"
  }, var.tags)
}

resource "aws_security_group" "private_link" {
  for_each    = { for item in var.network : item.name => item if item.private_link }
  name        = "databricks-${var.environment}-${each.key}-private-link"
  description = "Databricks private link between control plane and data plane"
  vpc_id      = module.vpc[each.key].vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = module.vpc[each.key].private_subnets_cidr_blocks
  }

  ingress {
    from_port   = 6666
    to_port     = 6666
    protocol    = "tcp"
    cidr_blocks = module.vpc[each.key].private_subnets_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge({
    Name = "databricks-${var.environment}-${each.key}-private-link"
  }, var.tags)
}