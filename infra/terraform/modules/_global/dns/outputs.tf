output "dns_zone_id" {
  description = "ID da zona Route 53"
  value       = aws_route53_zone.primary.zone_id
}

# Salvar o ID da zona gerada em um arquivo local
resource "local_file" "route53_zone_id" {
  content  = aws_route53_zone.primary.zone_id
  filename = "${path.module}/../../../route53_zone_id.txt"
}

output "name_servers" {
  description = "Name Servers do DNS"
  value = aws_route53_zone.primary.name_servers
}