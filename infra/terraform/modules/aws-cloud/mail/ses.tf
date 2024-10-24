# Cria o domínio no SES
resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain

  depends_on = [ null_resource.enable_user_workmail ]
}

resource "null_resource" "verify_identity" {
  triggers = {
      REGION = var.region
      EMAIL = "${local.no-reply_user}@${var.domain}"
      DOMAIN = substr(var.domain, 0, length(var.domain) - 3)
  }
  
  provisioner "local-exec" {
    when = create
    on_failure = fail
    interpreter = [  "PowerShell", "-Command" ]  
    command = <<EOT
      $email = "${self.triggers.EMAIL}"
      $region = "${self.triggers.REGION}"
      $domain = "${self.triggers.DOMAIN}"

      aws ses verify-email-identity --email-address $email --region $region

      do {
        Write-Host ('Clique no link de confirmação de identidade do email enviado para {0}' -f $email)
        Write-Host ('https://{0}.awsapps.com/mail' -f $domain)
        Write-Host ''
        
        # Checando status da verificação no SES
        $status = aws ses get-identity-verification-attributes --identities $email --region $region --output json
        
        # Usar GetEnumerator para acessar o objeto corretamente
        $verificationStatus = ($status.VerificationAttributes.GetEnumerator() | Where-Object { $_.Key -eq $email }).Value.VerificationStatus
        
        if ($verificationStatus -eq 'Success') {
          Write-Host ('A identidade do email {0} foi confirmada com sucesso!' -f $email)
          break
        } else {
          Write-Host ('Aguardando a confirmação da identidade do email {0} ...' -f $email)
        }

        Start-Sleep -Seconds 10
      } while ($verificationStatus -ne 'Success')
      EOT
  }

  depends_on = [ aws_ses_domain_identity.ses_domain ]
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

