module "ecs" {
  source = "../../terraform-aws-ecs-service"

  # Network
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  container_insights = false

  # App
  project_name = "demo"
  environment  = "dev"

  container_name  = "app"
  container_image = "nginx:latest"
  container_port  = 80

  # ECS
  desired_count = 1
  task_cpu      = "256"
  task_memory   = "512"

  # ALB
  health_check_path    = "/"
  acm_certificate_arn  = "arn:aws:acm:us-east-1:020262236467:certificate/cba4cc2a-45df-4413-8fd4-0d854591599f"

  # Logs
  aws_region   = "us-east-1"
  log_retention = 7

  # Tags
  global_tags = {
    project = "demo"
  }
}