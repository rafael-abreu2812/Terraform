locals {
  container_insights = var.container_insights ? "enabled" : "disabled"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = local.container_insights
  }
  tags = merge(
    var.global_tags,
    {
      environment = var.environment
    }
  )
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention

  tags = merge(
    var.global_tags,
    {
      environment = var.environment
    }
  )
}