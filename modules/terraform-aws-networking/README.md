# Terraform AWS Networking Module

This module provisions a production-grade AWS VPC with dynamic Multi-AZ support, allowing you to choose between a cost-optimized architecture or a highly available (HA) deployment.

## 💰 Estimated Monthly Cost (us-east-1)

> Based on default configuration running 24/7. Excludes data transfer charges.

### Option A: Cost-Optimized (single_nat_gateway = true)
| Resource        | Details                        | Est. Cost/month |
| --------------- | ------------------------------ | --------------- |
| NAT Gateway     | 1x, $0.045/h × 730h            | ~$32.85         |
| Elastic IP      | Attached to NAT (no extra cost)| $0.00           |
| VPC / Subnets   | No hourly charge               | $0.00           |
| **Total** |                                | **~$32.85/mo** |

### Option B: Highly Available - 3 AZs (single_nat_gateway = false)
| Resource        | Details                        | Est. Cost/month |
| --------------- | ------------------------------ | --------------- |
| NAT Gateways    | 3x, $0.045/h × 730h            | ~$98.55         |
| Elastic IPs     | Attached to NATs               | $0.00           |
| VPC / Subnets   | No hourly charge               | $0.00           |
| **Total** |                                | **~$98.55/mo** |

> ⚠️ **Note:** The NAT Gateway is the main cost driver of this module. Data processing fees ($0.045/GB) are additional. 
> Pricing source: [AWS VPC Pricing](https://aws.amazon.com/vpc/pricing/)

---

## 🏛️ Architecture

* Dynamic subnet provisioning (supports 2 or more Availability Zones).
* Creates 1 Public and 1 Private subnet per Availability Zone provided.
* Public subnets route traffic to an Internet Gateway.
* Private subnets route outbound traffic through NAT Gateways.
* **AZ-Agnostic:** CIDR blocks are automatically calculated to prevent overlaps regardless of the number of AZs.

---

## ⚙️ Inputs

| Name                 | Description                                                                                                                                           | Type         | Required | Default |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | -------- | ------- |
| `vpc_cidr`           | CIDR block for the VPC. Must be between /16 and /24.                                                                                                   | string       | yes      | n/a     |
| `project_name`       | Project identifier                                                                                                                                    | string       | yes      | n/a     |
| `environment`        | Environment name (e.g., dev, prod)                                                                                                                    | string       | yes      | n/a     |
| `availability_zones` | List of AZs to use (Minimum of 2 required for HA)                                                                                                     | list(string) | yes      | n/a     |
| `single_nat_gateway` | Determines the NAT Gateway deployment strategy. If true, provisions a shared NAT Gateway (cost-optimized). If false, deploys one per AZ (highly available). | bool         | no       | `true`  |
| `global_tags`        | Additional tags to apply to all resources                                                                                                             | map(string)  | no       | `{}`    |

---

## 📦 Outputs

| Name                         | Description                                |
| ---------------------------- | ------------------------------------------ |
| `vpc_id`                     | ID of the VPC                              |
| `vpc_cidr_block`             | CIDR block of the VPC                      |
| `public_subnet_ids`          | IDs of the public subnets                  |
| `public_subnet_cidr_blocks`  | CIDR blocks of the public subnets          |
| `private_subnet_ids`         | IDs of the private subnets                 |
| `private_subnet_cidr_blocks` | CIDR blocks of the private subnets         |
| `nat_gateway_ids`            | List of IDs of the created NAT Gateways    |

---

## 📝 Design Choice: Cost Optimization vs. High Availability

This module supports both **cost-efficient** (single shared NAT Gateway) and **highly available** (one NAT Gateway per AZ) architectures. 

By default, `single_nat_gateway` is set to `true` to prevent unexpected AWS charges in development environments. For production workloads, we highly recommend setting this variable to `false` to ensure AZ-level fault tolerance, aligning with the AWS Well-Architected Framework best practices.