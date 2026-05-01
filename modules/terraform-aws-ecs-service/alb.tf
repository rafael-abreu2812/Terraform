##### Load Balancer
  #### ALB
    resource "aws_lb" "main" {
      name               = "${var.project_name}-${var.environment}-alb"
      internal           = false
      load_balancer_type = "application"
      security_groups    = [aws_security_group.alb.id]
      subnets            = var.public_subnet_ids

      tags = merge(
        var.global_tags,
        {
          Name        = "${var.project_name}-${var.environment}-alb"
          environment = var.environment
        }
      )
    }
  #### Target Group
    resource "aws_lb_target_group" "main" {
      name        = "${var.project_name}-${var.environment}-tg"
      port        = var.container_port
      protocol    = "HTTP"
      vpc_id      = var.vpc_id
      target_type = "ip"

      health_check {
        path                = var.health_check_path
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 3
      }

      tags = merge(
        var.global_tags,
        {
          Name        = "${var.project_name}-${var.environment}-tg"
          environment = var.environment
        }
      )
    }


  #### HTTP Listener
    resource "aws_lb_listener" "http" {
      load_balancer_arn = aws_lb.main.arn
      port              = 80
      protocol          = "HTTP"

      default_action {
        type = "redirect"

        redirect {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }
    }
  #### HTTPS Listener
    resource "aws_lb_listener" "https" {
      load_balancer_arn = aws_lb.main.arn
      port              = 443
      protocol          = "HTTPS"
      ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn   = var.acm_certificate_arn

      default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.main.arn
      }
    }
#####