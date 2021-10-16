terraform {
  # Require Terraform at exactly version 1.0.9
  required_version = "= 1.0.9"
}

resource "aws_lb" "alb-servers" {
  name               = var.alb_name
  load_balancer_type = "application"

  subnets = var.subnet_ids

  security_groups = [aws_security_group.sg-alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb-servers.arn
  port              = local.http_port
  protocol          = local.http_protocol

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "sg-alb" {
  name = var.alb_name
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-alb.id

  # Allow inbound HTTP requests
  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.sg-alb.id

  # Allow all outbound requests
  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

locals {
  http_port     = 80
  any_port      = 0
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  http_protocol = "HTTP"
  all_ips       = ["0.0.0.0/0"]
}
