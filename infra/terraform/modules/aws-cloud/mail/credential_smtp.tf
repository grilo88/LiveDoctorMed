locals {
  no-reply_user = [for user in var.workmail_users : user if user.id == "no-reply"][0].user
}

variable "iam_user_name" {
  default = "SES_SMTP_User"
}

resource "aws_ses_email_identity" "email_identity" {
  email = "${local.no-reply_user}@${var.domain}" 
  depends_on = [ null_resource.workmail_user ]
}

resource "aws_iam_user" "ses_smtp_user" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "ses_smtp_policy" {
  name        = "SES_SMTP_Policy"
  description = "Policy to allow SES email sending"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "ses:SendEmail"
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "ses:SendRawEmail"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 3. Anexar a política ao usuário IAM
resource "aws_iam_policy_attachment" "ses_smtp_policy_attachment" {
  name       = "attach-ses-smtp-policy"
  policy_arn = aws_iam_policy.ses_smtp_policy.arn
  users      = [aws_iam_user.ses_smtp_user.name]
}

# 4. Criar uma chave de acesso para o usuário IAM
resource "aws_iam_access_key" "ses_smtp_access_key" {
  user = aws_iam_user.ses_smtp_user.name
}

# 5. Criar o arquivo com as credenciais SMTP
resource "local_file" "smtp_credentials_file" {
  filename = "${path.module}/smtp_credentials.txt"  # Caminho onde o arquivo será salvo
  content  = <<-EOT
    SMTP Username: ${aws_iam_user.ses_smtp_user.name}
    SMTP Password: ${aws_iam_access_key.ses_smtp_access_key.secret}
    SMTP Endpoint: email-smtp.us-east-1.amazonaws.com  # Ajuste conforme sua região
  EOT
}

# 6. Output das credenciais SMTP
output "smtp_username" {
  value = aws_iam_user.ses_smtp_user.name
}

output "smtp_password" {
  value = aws_iam_access_key.ses_smtp_access_key.secret
}

output "smtp_endpoint" {
  value = "email-smtp.${var.region}.amazonaws.com"  # Ajuste conforme sua região
}