resource "aws_route53_zone" "primary" {
  name    = var.domain
  comment = "Gerenciado pelo Terraform"
}