# Cria o domínio no SES
resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain
}

# Habilita assinatura DKIM no SES
resource "aws_ses_domain_dkim" "ses_dkim" {
  domain = var.domain
}

# Configurar o Email From Domain no SES
resource "aws_ses_domain_mail_from" "mail_from" {
  domain                  = var.domain
  mail_from_domain        = "bounce.${var.domain}"  # Subdomínio para bounces
  behavior_on_mx_failure  = "UseDefaultValue"

  depends_on = [aws_ses_domain_identity.ses_domain]
}

# Criar registros DNS no Route 53 para MAIL FROM
resource "aws_route53_record" "mail_from_mx" {
  zone_id = local.zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "MX"
  ttl     = 300
  records = ["10 feedback-smtp.${var.region}.amazonses.com"]
}

resource "aws_route53_record" "mail_from_txt" {
  zone_id = local.zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:amazonses.com -all"]
}

# Registros DKIM no Route 53
resource "aws_route53_record" "dkim_records" {
  count   = 3
  zone_id = local.zone_id
  name    = "${aws_ses_domain_dkim.ses_dkim.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_ses_domain_dkim.ses_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]

  # Garante que os registros DKIM sejam criados após o null_resource
  depends_on = [null_resource.wait_for_dkim]
}

# Null resource para aguardar a conclusão da criação do DKIM
resource "null_resource" "wait_for_dkim" {
  # Usamos um trigger que muda sempre que o DKIM é criado
  triggers = {
    dkim_tokens = join(",", aws_ses_domain_dkim.ses_dkim.dkim_tokens)
  }

  provisioner "local-exec" {
    command = "echo DKIM tokens updated: ${self.triggers.dkim_tokens}"
  }
}

resource "aws_route53_record" "ses_verification_record" {
  zone_id = local.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.ses_domain.domain}"
  type    = "TXT"
  ttl     = 300
  records = [aws_ses_domain_identity.ses_domain.verification_token]
}

output "ses_verification_status" {
  value = aws_ses_domain_identity.ses_domain.id
}