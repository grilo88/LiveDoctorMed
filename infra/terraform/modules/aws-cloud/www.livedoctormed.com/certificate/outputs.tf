output "aws_acm_certificate_cert_arn" {
  description = "ID do certificado"
  value       = aws_acm_certificate.cert.arn
}