resource "random_password" "no_reply_password" {
  length  = 16
  special = true
  override_special = "_%@"
}

# Salva a senha em um arquivo local
resource "local_file" "workmail_user_password" {
  filename = "${var.no_reply_username}_workmail_password.txt"
  content  = random_password.no_reply_password.result
}

# Criação da organização WorkMail com AWS CLI
resource "null_resource" "create_workmail_org" {
  provisioner "local-exec" {
    when = create
    on_failure = fail
    environment = {
      ORG_ALIAS = var.organization
      REGION    = var.region
    }
    command = <<EOT
      aws workmail create-organization --alias $ORG_ALIAS --region $REGION --output text
    EOT
  }

  triggers = {
    ORG_ALIAS = var.organization
  }

  # Deleta a organização quando o Terraform destroy for aplicado
  provisioner "local-exec" {
    when = destroy
    on_failure = continue
    command = <<EOT
      aws workmail delete-organization --organization-id ${self.triggers.ORG_ALIAS} --delete-mailbox-content
    EOT
  }
}

# Cria o usuário no-reply no WorkMail com a senha aleatória
resource "null_resource" "create_workmail_user" {
  provisioner "local-exec" {
    when    = create
    on_failure = fail
    environment = {
      EMAIL_USERNAME    = var.no_reply_username
      EMAIL_PASSWORD    = random_password.no_reply_password.result
      EMAIL_DISPLAY     = "No Reply"
    }
    command = <<EOT
      aws workmail create-user --organization-id $(aws workmail list-organizations --query 'Organizations[0].OrganizationId' --output text) --name $EMAIL_USERNAME --display-name $EMAIL_DISPLAY --password '$EMAIL_PASSWORD'
    EOT
  }

  triggers = {
    ORG_ALIAS         = var.organization,
    EMAIL_USERNAME    = var.no_reply_username
  }

  # Destrói o usuário no-reply quando o Terraform destroy for aplicado
  provisioner "local-exec" {
    when    = destroy
    on_failure = continue
    command = <<EOT
      aws workmail list-organizations --query 'Organizations[?Alias==\`${self.triggers.ORG_ALIAS}\`].OrganizationId' --output text | xargs -I {} aws workmail delete-user --organization-id {} --user-id $(aws workmail list-users --organization-id {} --query 'Users[?Name==\`${self.triggers.EMAIL_USERNAME}\`].Id' --output text)
    EOT
  }

  depends_on = [null_resource.create_workmail_org]
}

# Ativa a caixa de correio do usuário no WorkMail
resource "null_resource" "enable_user_workmail" {
  provisioner "local-exec" {
    when = create
    on_failure = fail
    command = <<EOT
      aws workmail register-to-workmail --organization-id $(aws workmail list-organizations --query 'Organizations[0].OrganizationId' --output text) --entity-id $(aws workmail list-users --organization-id $(aws workmail list-organizations --query 'Organizations[0].OrganizationId' --output text) --query 'Users[?Name==\`${var.no_reply_username}\`].Id' --output text) --email ${var.no_reply_username}@${var.domain}
    EOT
  }

  depends_on = [null_resource.create_workmail_user]
}
