terraform {
  # Require Terraform at exactly version 1.0.9
  required_version = "= 1.0.9"

  backend "s3" {
    key = "modules/examples/mysql/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"

  # Allow any 3.x version of the AWS provider
  version = "~> 3.0"
}

module "mysql" {
  source = "../../data-stores/mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
