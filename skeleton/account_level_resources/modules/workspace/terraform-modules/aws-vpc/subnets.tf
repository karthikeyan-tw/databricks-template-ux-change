locals {
  # Define length of subnets
  len_public_subnets  = max(length(var.public_subnet_names))
  len_private_subnets = max(length(var.private_subnet_names))

  max_subnet_length = max(
    local.len_private_subnets,
    local.len_public_subnets,
  )

  create_public_subnets  = local.len_public_subnets > 0
  create_private_subnets = local.len_private_subnets > 0

  # Set the CIDR block and split into 2 partitions for public and private subnets.
  # By default, the partitions skip 2 new bits corresponding to maximum of 4 subnets per partition.
  partitions = cidrsubnets(aws_vpc.this.cidr_block, [for i in range(2) : var.subnet_partition_newbits]...)
  newbits    = var.subnet_newbits - var.subnet_partition_newbits

  # Calculate CIDR blocks dynamically based on 1st partition (Public) and 2nd partition (Private)
  public_subnet_cidrs  = cidrsubnets(local.partitions[0], [for s in range(local.len_public_subnets) : local.newbits]...)
  private_subnet_cidrs = cidrsubnets(local.partitions[1], [for s in range(local.len_private_subnets) : local.newbits]...)
}

################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
  count = local.create_public_subnets && (!var.one_nat_gateway_per_az || local.len_public_subnets >= length(var.azs)) ? local.len_public_subnets : 0

  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block           = element(concat(local.public_subnet_cidrs, [""]), count.index)
  vpc_id               = aws_vpc.this.id

  tags = merge(
    {
      Name = try(
        var.public_subnet_names[count.index],
        format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
      )
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  count = local.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.name}-${var.public_subnet_suffix}"
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, 0)
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block           = element(concat(local.private_subnet_cidrs, [""]), count.index)
  vpc_id               = aws_vpc.this.id

  tags = merge(
    {
      Name = try(
        var.private_subnet_names[count.index],
        format("${var.name}-${var.private_subnet_suffix}-%s", element(var.azs, count.index))
      )
    },
    var.tags
  )
}

# There are as many routing tables as the number of NAT gateways
resource "aws_route_table" "private" {
  count = local.create_private_subnets && local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}" : format(
        "${var.name}-${var.private_subnet_suffix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}