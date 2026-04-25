locals {
  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 0),
    cidrsubnet(var.vpc_cidr, 8, 1)
  ]

  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 2),
    cidrsubnet(var.vpc_cidr, 8, 3)
  ]
}

resource "aws_vpc" "main" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags,
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
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-public-${tonumber(each.key) + 1}"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
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
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-private-${tonumber(each.key) + 1}"
    }
  )
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["0"].id # Uses the first public subnet created

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-nat-gateway"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-private-rt"
    }
  )
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id # Route to the NAT GW in the public subnet
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
#####

# This is basic networking module for a new development AWS Accounts, feel free to use as you wish!
# You can see more details about how to use this in the README file in this folder