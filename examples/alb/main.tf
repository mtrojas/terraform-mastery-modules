terraform {
  # Require Terraform at exactly version 1.0.9
  required_version = "= 1.0.9"

  backend "s3" {
    key = "modules/examples/alb/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"

  # Allow any 3.x version of the AWS provider
  version = "~> 3.0"
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
