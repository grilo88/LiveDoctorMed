locals {
  workmail_users_map = { for user in var.workmail_users : user.id => user }
}

resource "random_password" "user_password" {
  for_each = local.workmail_users_map

  length  = 16
  special = true
  override_special = "_%@$&"
  numeric = true
}

# Salva a senha em um arquivo local
resource "local_file" "workmail_user_password" {
  for_each = local.workmail_users_map

  filename = "${path.module}/email_password_${each.key}.txt"
  content  = random_password.user_password[each.key].result
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
      aws workmail update-default-mail-domain --organization-id $orgId --domain-name $emailDomain --region $region

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
  for_each = local.workmail_users_map

  triggers = {
    ORG_ALIAS         = var.organization,
    REGION            = var.region,
    EMAIL_USERNAME    = each.value.user,
    EMAIL_DISPLAY     = each.value.display,
    EMAIL_PASSWORD    = random_password.user_password[each.key].result
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
      aws workmail create-user --organization-id $orgId --name $emailUsername --display-name $emailDisplay --password '$emailPassword' --region $region

      while ($true) {
        $status = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUserName' && State=='DISABLED'].State" --region $region --output text
        if ($status -eq 'DISABLED') {
          Write-Host 'Workmail User '$userId' is created!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    on_failure = fail
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      $emailUsername = "${self.triggers.EMAIL_USERNAME}"

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $orgId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      $userId = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUsername' && State=='DISABLED'].Id" --region $region --output text

      if (-not $orgId -or -not $userId) {
        throw "O ID da organização ou o ID do usuário não pode estar vazio."
      }
  
      while ($true) {
        aws workmail delete-user --organization-id $orgId --user-id $userId --region $region
        $status = aws workmail list-users --organization-id $orgId --query "Users[?Id=='$userId'].State" --region $region --output text
        
        # Verifica se o usuário foi removido ou está desabilitado
        if ($status -eq '' -or $status -eq 'DELETED') {
            Write-Host "WorkMail User '$userId' is deleted or disabled!"
            break
        } else {
            Write-Host "Waiting for user '$userId' to be deleted or disabled..."
            Start-Sleep -Seconds 1
        }
    }
    EOT
  }

  depends_on = [null_resource.workmail_domain]
}

# # Ativa a caixa de correio do usuário no WorkMail
resource "null_resource" "enable_user_workmail" {
  for_each = local.workmail_users_map

  triggers = {
    ORG_ALIAS = var.organization
    REGION = var.region
    EMAIL_USERNAME = each.value.user
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
      $userId = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUsername' && State=='DISABLED'].Id" --region $region --output text
      
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

provisioner "local-exec" {
    when    = destroy
    on_failure = fail
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      $orgAlias = "${self.triggers.ORG_ALIAS}"
      $region = "${self.triggers.REGION}"
      $emailUsername = "${self.triggers.EMAIL_USERNAME}"

      $ErrorActionPreference = "Stop"
      $orgAlias = $orgAlias.ToLower()
      $region = $region.ToLower()

      $orgId = aws workmail list-organizations --query "OrganizationSummaries[?Alias=='$orgAlias' && State=='Active'].OrganizationId" --region $region --output text
      $userId = aws workmail list-users --organization-id $orgId --query "Users[?Name=='$emailUsername' && State=='ENABLED'].Id" --region $region --output text

      if (-not $orgId -or -not $userId) {
        throw "O ID da organização ou o ID do usuário não pode estar vazio."
      }

      while ($true) {
        aws workmail deregister-from-work-mail --organization-id $orgId --entity-id $userId --region $region
        $status = aws workmail list-users --organization-id $orgId --query "Users[?Id=='$userId'].State" --region $region --output text

        if ($status -eq '' -or $status -eq 'DISABLED' -or $status -eq 'DELETED') {
          Write-Host 'Workmail User '$userId' is disabled!'
          break
        } else {
          Start-Sleep -Seconds 1
        }
      }
    EOT
  }

  depends_on = [ null_resource.workmail_user ]
}
