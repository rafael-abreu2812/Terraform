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
  region = var.region

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

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]

  tags = {
    Name = "${var.project_name}-public-subnet-${each.key}"
  }
}