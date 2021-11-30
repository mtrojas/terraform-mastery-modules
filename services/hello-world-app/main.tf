terraform {
  # Require Terraform at exactly version 1.0.9
  required_version = "= 1.0.9"
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name  = "hello-world-${var.environment}"
  ami           = var.ami
  user_data     = data.template_file.user_data.rendered
  instance_type = var.instance_type

  min_size           = var.min_size
  max_size           = var.max_size
  enable_autoscaling = var.enable_autoscaling

  subnet_ids        = local.subnet_ids
  target_group_arns = [aws_lb_target_group.tg_servers.arn]
  health_check_type = "ELB"

  custom_tags = var.custom_tags
}

module "alb" {
  source = "../../networking/alb"

  alb_name   = "hello-world-${var.environment}"
  subnet_ids = local.subnet_ids
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    db_address  = local.mysql_config.address
    db_port     = local.mysql_config.port
    server_text = var.server_text
  }
}

resource "aws_lb_target_group" "tg_servers" {
  name     = "hello-world-${var.environment}"
  port     = var.server_port
  protocol = local.http_protocol
  vpc_id   = local.vpc_id

  health_check {
    path                = "/"
    protocol            = local.http_protocol
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_servers.arn
  }
}

locals {
  http_protocol = "HTTP"
}







