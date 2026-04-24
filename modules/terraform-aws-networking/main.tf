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
    for_each = aws_subnet.public # Get the output of created public subnets

    subnet_id      = each.value.id
    route_table_id = aws_route_table.public.id
  }
##### 




