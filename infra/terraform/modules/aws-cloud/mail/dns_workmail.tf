# Registro MX para o WorkMail
resource "aws_route53_record" "workmail_mx" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = 600
  records = ["10 inbound-smtp.${var.region}.amazonaws.com."]
}

# Registro TXT para SPF (envio de email autorizado)
resource "aws_route53_record" "workmail_spf" {
  zone_id = local.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com ~all"]
}

# Registro CNAME para o autodiscover do WorkMail
resource "aws_route53_record" "workmail_autodiscover" {
  zone_id = local.zone_id
  name    = "autodiscover.${var.domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["autodiscover.mail.${var.region}.awsapps.com."]
}

# Registro TXT para DMARC
resource "aws_route53_record" "dmarc" {
  zone_id = local.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 600
  records = [
    "v=DMARC1; p=quarantine; rua=mailto:dmarc-reports@${var.domain}; ruf=mailto:dmarc-reports@${var.domain}; fo=1"
  ]
}