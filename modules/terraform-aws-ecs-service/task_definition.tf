locals {
  default_container_definitions = [
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-${var.environment}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ]

  container_definitions = var.container_definitions != null ? var.container_definitions : local.default_container_definitions
}


resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = local.container_definitions

   tags = merge(
      var.global_tags,
      {
        Name        = "${var.project_name}-${var.environment}-task"
        environment = var.environment
      }
   )
}