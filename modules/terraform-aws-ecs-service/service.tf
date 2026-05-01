##### ECS Service
  resource "aws_ecs_service" "main" {
    depends_on = [aws_lb_listener.https]

    name            = "${var.project_name}-${var.environment}-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.main.arn
    desired_count   = var.desired_count
    launch_type     = "FARGATE"

    network_configuration {
      subnets          = var.private_subnet_ids
      security_groups  = [aws_security_group.ecs.id]
      assign_public_ip = false
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.main.arn
      container_name   = var.container_name
      container_port   = var.container_port
    }

    tags = merge(
      var.global_tags,
      {
        Name        = "${var.project_name}-${var.environment}-service"
        environment = var.environment
      }
    )
  }
#####