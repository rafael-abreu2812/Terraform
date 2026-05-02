variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be created."
  type        = string
}

variable "public_subnet_ids" {
  description = "ID of public subnets, which contains a route to internet gateway."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where ECS tasks will run."
  type        = list(string)
}

variable "container_insights" {
  description = "Container Insights provides enhanced observability for ECS workloads, use true to enable"
  type        = bool
}

variable "container_definitions" {
  description = "Custom ECS container definitions. If null, the module creates a default container definition."
  type        = any
  default     = null
}

variable "container_name" {
  description = "Name of the container."
  type        = string
}

variable "container_image" {
  description = "Container image to run."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container."
  type        = number
  default     = 8080
}

variable "task_cpu" {
  description = "CPU units for the ECS task."
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory for the ECS task."
  type        = string
  default     = "512"
}

variable "execution_role_policy_json" {
  description = "Optional additional IAM policy JSON for the ECS task execution role."
  type        = string
  default     = null
}

variable "desired_count" {
  description = "Number of ECS tasks to run."
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "AWS region used by the CloudWatch Logs driver."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate used by the HTTPS listener."
  type        = string
}

variable "health_check_path" {
  description = "Health check path for the target group."
  type        = string
  default     = "/"
}

variable "log_retention" {
  description = "Retention of the logs in CloudWatch Log Group, in days."
  type        = number
  default     = 7
}

variable "global_tags" {
  type    = map(string)
  default = {}
}