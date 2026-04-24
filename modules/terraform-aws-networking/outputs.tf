output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets."
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets."
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
}