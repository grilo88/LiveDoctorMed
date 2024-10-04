output "aws_cloudfront_distribution_website_domain_name" {
  description = "aws_cloudfront_distribution_website_domain_name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "aws_cloudfront_distribution_website_hosted_zone_id" {
  description = "aws_cloudfront_distribution_website_hosted_zone_id"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

# Salvar o ID da zona gerada em um arquivo local
resource "local_file" "route53_zone_id" {
  content  = aws_cloudfront_distribution.website.id
  filename = "${path.module}/../../../cloudfront_distribution_id-${var.subdomain}.txt"
}