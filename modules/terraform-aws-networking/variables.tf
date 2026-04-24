variable "vpc_cidr" {
  type = string
  validation {
    condition = (
      can(cidrsubnet(var.vpc_cidr, 0, 0)) &&
      tonumber(split("/", var.vpc_cidr)[1]) >= 16 &&
      tonumber(split("/", var.vpc_cidr)[1]) <= 24
    )

    error_message = "The VPC CIDR block must be a valid IPv4 CIDR between /16 and /24."
  }
}

variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "tags" {
  type = ob
}