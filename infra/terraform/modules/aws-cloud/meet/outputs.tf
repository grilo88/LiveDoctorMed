output "aws_lb_app_lb_dns_name" {
  description = "Dns name do load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "aws_lb_app_lb_zone_id" {
  description = "Zona id do load balancer"
  value       = aws_lb.app_lb.zone_id
}