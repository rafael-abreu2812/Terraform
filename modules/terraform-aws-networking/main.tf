locals {
  az_count = length(var.availability_zones)

  # Dynamically generate public CIDRs (e.g., if 3 AZs: indices 0, 1, 2)
  public_subnet_cidrs = [
    for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 8, i)
  ]

  # Dynamically generate private CIDRs (e.g., if 3 AZs: indices 3, 4, 5)
  private_subnet_cidrs = [
    for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 8, i + local.az_count)
  ]

  # Determine how many NAT Gateways to create
  nat_gateway_count = var.single_nat_gateway ? 1 : local.az_count
}

resource "aws_vpc" "main" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr
  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}

##### Public Subnet Block
resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in local.public_subnet_cidrs :
    idx => cidr
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-${tonumber(each.key) + 1}"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public # Associates each public subnet with the public route table.

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
##### 

##### Private Subnet Block
resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in local.private_subnet_cidrs :
    idx => cidr
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-${tonumber(each.key) + 1}"
    }
  )
}

resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[tostring(count.index)].id # Uses the first public subnet created

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-nat-gateway-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.global_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-rt-${tonumber(each.key) + 1}"
    }
  )
}

resource "aws_route" "private_nat_access" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[tonumber(each.key)].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
#####

# This is basic networking module for a new development AWS Accounts, feel free to use as you wish!
# You can see more details about how to use this in the README file in this folder