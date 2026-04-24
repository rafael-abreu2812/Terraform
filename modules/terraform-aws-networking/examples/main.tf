module "network" {
  source = "../"

  vpc_cidr = "10.0.0.0/16"

  project_name = "demo"
  environment  = "dev"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  tags = {
    owner = "best-user-of-the-world"
  }
}