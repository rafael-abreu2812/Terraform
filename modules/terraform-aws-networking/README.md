# Terraform AWS Networking Module

This module provisions a production-style AWS VPC with:

* Public and private subnets
* Internet Gateway
* NAT Gateway
* Route tables for public and private traffic
* Multi-AZ subnet distribution

## Architecture

* 2 public subnets (one per AZ)
* 2 private subnets (one per AZ)
* Public subnets route traffic to an Internet Gateway
* Private subnets route outbound traffic through a NAT Gateway

---

## Usage

```hcl
module "network" {
  source = "github.com/your-username/terraform-aws-networking-module"

  vpc_cidr = "10.0.0.0/16"

  project_name = "my-project"
  environment  = "dev"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  tags = {
    owner = "team-devops"
  }
}
```

---

## Inputs

| Name               | Description            | Type         | Required |
| ------------------ | ---------------------- | ------------ | -------- |
| vpc_cidr           | CIDR block for the VPC | string       | yes      |
| project_name       | Project identifier     | string       | yes      |
| environment        | Environment name       | string       | yes      |
| availability_zones | List of AZs            | list(string) | yes      |
| tags               | Additional tags        | map(string)  | no       |

---

## Outputs

| Name               | Description        |
| ------------------ | ------------------ |
| vpc_id             | VPC ID             |
| public_subnet_ids  | Public subnet IDs  |
| private_subnet_ids | Private subnet IDs |
| nat_gateway_id     | NAT Gateway ID     |

---

## Notes

* The module derives subnet CIDRs automatically from the VPC CIDR.
* The module uses a single NAT Gateway for cost efficiency.
* Subnets are distributed across two Availability Zones.

---

## Requirements

* Terraform >= 1.5
* AWS Provider ~> 5.0
