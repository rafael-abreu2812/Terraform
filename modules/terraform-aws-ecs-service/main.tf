locals {
  containerInsights = var.container_insights ? "enabled" : disabled
}

resource "aws_ecs_cluster" "foo" {
  name = "white-hart"

  setting {
    name  = "containerInsights"
    value = local.containerInsights
  }
}