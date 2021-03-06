terraform {
  # Allow any 1.x Terraform version
  required_version = "~> 1.0"

  required_providers {
    # Allow any 3.x version of the AWS provider
    aws = {
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key = "modules/examples/hello-world-app/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "hello_world_app" {
  source = "../../services/hello-world-app"

  server_text = "My Example Deployment v0.0.1 of Hello World App"
  environment = "example"

  mysql_config = var.mysql_config

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false

  custom_tags = {
    Owner       = "team-devops"
    DeployedBy  = "terraform"
    Environment = "example"
  }
}

# module "mysql" {
#   source = "../../data-stores/mysql"

#   db_name     = var.db_name
#   db_username = var.db_username
#   db_password = var.db_password
# }
