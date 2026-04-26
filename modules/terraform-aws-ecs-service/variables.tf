variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "container_insights" {
  description = "Container Insights provides enhanced observability for ECS workloads, use true to enable"
  type        = bool
}

variable "container_port" {
  description = "Container port for ALB access"
  type = number
  default = 8080
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