variable "vpc_cidr" {
  description = "CIDR block for the VPC. Must be a valid IPv4 CIDR between /16 and /24."
  type        = string
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

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two availability zones must be provided."
  }
}

variable "global_tags" {
  type    = map(string)
  default = {}
}