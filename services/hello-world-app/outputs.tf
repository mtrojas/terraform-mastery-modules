# output "alb_dns_name" {
#   value       = aws_lb.alb-servers.dns_name
#   description = "The domain name of the load balancer"
# }

# output "asg_name" {
#   value       = aws_autoscaling_group.asg-servers.name
#   description = "The name of the Auto Scaling Group"
# }

output "alb_security_group_id" {
  value       = aws_security_group.sg-alb.id
  description = "The ID of the Security Group attached to the Application Load Balancer"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "The name of the Auto Scaling Group"
}

output "instance_security_group_id" {
  value       = module.asg.instance_security_group_id
  description = "The ID of the EC2 Instance Security Group"
}
