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
    key = "modules/examples/alb/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "alb" {
  source = "../../networking/alb"

  alb_name   = var.alb_name
  subnet_ids = data.aws_subnet_ids.default.ids
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
