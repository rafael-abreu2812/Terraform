# 🚀 Production-Grade AWS Terraform Architecture

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active_Development-success?style=for-the-badge)

A curated collection of production-ready, highly available Terraform modules for AWS. 

Unlike standard open-source modules that act as thin wrappers around individual AWS resources, these modules are **Architecture-First** and **Opinionated**. They are designed to solve real-world infrastructure scenarios, encapsulating enterprise best practices for Security, FinOps, and High Availability.

---

## 🧠 Core Philosophy

This repository demonstrates how to build cloud infrastructure the way top-tier tech companies do:

- **🔐 Secure by Default:** Least-privilege IAM roles, private networking for compute/data layers, and restrictive security groups.
- **💸 FinOps Aware:** Built-in cost optimization toggles (e.g., single vs. multi-AZ NAT Gateways) so developers can easily switch between cheap dev environments and resilient production environments.
- **🏗️ Composable & Decoupled:** Modules can be stacked to build a complete platform, or used entirely independently with existing infrastructure.
- **🏷️ Standardized Operations:** Consistent tagging, naming conventions, and environment isolation.

---

## 📦 Module Ecosystem

The repository is structured into distinct architectural layers. 

| Layer | Module | Description |
| :--- | :--- | :--- |
| **Networking** | [`terraform-aws-networking`](modules/terraform-aws-networking/) | Dynamic VPC, Public/Private Subnets, Multi-AZ routing, and Cost-Optimized NAT Gateways. |
| **Compute** | [`terraform-aws-ecs-service`](modules/terraform-aws-ecs-service/) | AWS Fargate ECS service with ALB, HTTPS enforcement, and CloudWatch logging. |

### 🗺️ Future Roadmap
* *Database Layer: Amazon RDS PostgreSQL (Multi-AZ)* ⏳
* *Caching Layer: Amazon ElastiCache (Redis)* ⏳
* *Security: AWS WAF & Bastion Host* ⏳

---

## 🏛️ Architecture Overview

When composed together, these modules instantly provision a Well-Architected AWS web application environment. The diagram below illustrates the current standard deployment:

```mermaid
flowchart TB
    User(["👤 User"])
    User -->|"HTTPS :443"| ALB
    User -->|"HTTP :80 → 301"| ALB

    subgraph VPC["VPC (terraform-aws-networking)"]
        subgraph Public["Public Subnets (AZ-a, AZ-b)"]
            IGW["Internet Gateway"]
            ALB["Application Load Balancer"]
            NAT["NAT Gateway"]
        end

        subgraph Private["Private Subnets (AZ-a, AZ-b)"]
            ECS1["ECS Task (Fargate)"]
            ECS2["ECS Task (Fargate)"]
        end

        IGW <--> ALB
        ALB -->|"forward"| ECS1
        ALB -->|"forward"| ECS2
        ECS1 -->|"outbound only"| NAT
        ECS2 -->|"outbound only"| NAT
    end

    ECS1 --> CW["☁️ CloudWatch Logs"]
    ECS2 --> CW
    NAT -->|"outbound"| Internet(["🌐 Internet"])