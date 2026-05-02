module "network" {
  source = "../terraform-aws-networking"

  vpc_cidr = "10.0.0.0/16"

  project_name = "demo"
  environment  = "dev"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  global_tags = {
    owner = "best-user"
  }
}

module "ecs" {
  source = "../terraform-aws-ecs-service"
  depends_on = [ module.network ]

  # Network
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  

  # App
  project_name = "demo"
  environment  = "dev"
  container_insights = false
  container_name  = "app"
  container_image = "nginx:latest"
  container_port  = 80

  # ECS
  desired_count = 1
  task_cpu      = "256"
  task_memory   = "512"

  # ALB
  health_check_path    = "/"
  acm_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/your-certificate-id"

  # Logs
  aws_region   = "us-east-1"
  log_retention = 7

  # Tags
  global_tags = {
    project = "demo"
  }
}