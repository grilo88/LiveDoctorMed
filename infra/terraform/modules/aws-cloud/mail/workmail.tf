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

resource "null_resource" "workmail_organization" {
  triggers = {
    ORG_ALIAS = var.organization
    REGION    = var.region
  }

  provisioner "local-exec" {
    when = create
    on_failure = fail
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      aws workmail create-organization --alias $orgAlias --region $region --output text

      while ($true) {
        $status = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].State" --region $region --output text
        if ($status -eq 'ACTIVE') {
          Write-Host 'Workmail Organization '$orgAlias' is active!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }
  
  provisioner "local-exec" {
    when = destroy
    on_failure = continue
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      
      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $organizationId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      aws workmail delete-organization --organization-id $organizationId --force-delete --delete-directory --region $region

      while ($true) {
        $status = aws workmail list-organizations --query "OrganizationSummaries[?OrganizationId=='$organizationId'].State" --region $region --output text
        if ($status -eq 'DELETED') {
          Write-Host 'Workmail Organization '$orgAlias' is deleted!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }
}

# Criação do domínio WorkMail com AWS CLI
resource "null_resource" "workmail_domain" {
  triggers = {
    ORG_ALIAS = var.organization
    REGION    = var.region
    EMAIL_DOMAIN    = var.domain
  }

  provisioner "local-exec" {
    when = create
    on_failure = fail
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      $emailDomain = "${self.triggers.EMAIL_DOMAIN}"

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $orgId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      aws workmail register-mail-domain --organization-id $orgId --domain-name $emailDomain --region $region

      while ($true) {
        $domain = aws workmail list-mail-domains --organization-id $orgId --region $region --query "MailDomains[?DomainName=='$emailDomain'].DomainName" --output text
        if ($domain -eq $emailDomain) {
          Write-Host 'Workmail Domain '$emailDomain' is created!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }

  depends_on = [ null_resource.workmail_organization ]
}

# Cria o usuário no-reply no WorkMail com a senha aleatória
resource "null_resource" "workmail_user" {
  triggers = {
    ORG_ALIAS         = var.organization,
    REGION            = var.region,
    EMAIL_USERNAME    = var.no_reply_username,
    EMAIL_PASSWORD    = random_password.no_reply_password.result,
    EMAIL_DISPLAY     = "No Reply"
  }

  provisioner "local-exec" {
    when    = create
    on_failure = fail
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      $emailUsername = "${self.triggers.EMAIL_USERNAME}"
      $emailPassword = "${self.triggers.EMAIL_PASSWORD}"
      $emailDisplay = "${self.triggers.EMAIL_DISPLAY}"

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $orgId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      aws workmail create-user --organization-id $orgId --name $emailUsername --display-name $emailDisplay --password $emailPassword --region $region
      $userId = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUsername'].Id" --region $region --output text

      while ($true) {
        $status = aws workmail list-users --organization-id $orgId --query "Users[?Id=='$userId'].State" --region $region --output text
        if ($status -eq 'DISABLED') {
          Write-Host 'Workmail User '$userId' is created!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }

  # Destrói o usuário no-reply quando o Terraform destroy for aplicado
  provisioner "local-exec" {
    when    = destroy
    on_failure = continue
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      $emailUsername = "${self.triggers.EMAIL_USERNAME}"

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $orgId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      $userId = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUsername'].Id" --region $region --output text
      aws workmail delete-user --organization-id $orgId --user-id $userId --region $region --output text
    EOT
  }

  depends_on = [null_resource.workmail_domain]
}

# # Ativa a caixa de correio do usuário no WorkMail
resource "null_resource" "enable_user_workmail" {
  triggers = {
    ORG_ALIAS = var.organization
    REGION = var.region
    EMAIL_USERNAME = var.no_reply_username
    EMAIL_DOMAIN = var.domain
  }

  provisioner "local-exec" {
    when    = create
    on_failure = fail
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      $emailUsername = "${self.triggers.EMAIL_USERNAME}"
      $emailDomain = "${self.triggers.EMAIL_DOMAIN}"
      $email = $emailUsername + "@" + $emailDomain

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $orgId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      $userId = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUsername'].Id" --region $region --output text

      aws workmail register-to-work-mail --organization-id $orgId --entity-id $userId --email $email --region $region

      while ($true) {
        $status = aws workmail list-users --organization-id $orgId --query "Users[?Id=='$userId'].State" --region $region --output text
        if ($status -eq 'ENABLED') {
          Write-Host 'Workmail User '$userId' is enabled!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }

  depends_on = [ null_resource.workmail_user ]
}
