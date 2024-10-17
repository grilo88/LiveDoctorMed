region = "us-east-1"
domain = "livedoctormed.com"
organization = "LiveDoctorMed"

# Www Project
www_subdomain = "dev"
www_project   = "ldm-useast1-dev-www"

# Meet Project
meet_subdomain   = "meet-dev"
meet_project     = "ldm-useast1-dev-meet"

meet_base_ami_id = "ami-0e86e20dae9224db8"
meet_web_instance_type = "t3.micro"

mail_workmail_users = [
  {
    id      = "no-reply"
    user    = "no-reply"
    display = "No Reply"
  },
  {
    id      = "dmarc"
    user    = "dmarc-reports"
    display = "DMARC"
  },
  {
    id      = "support-01"
    user    = "support"
    display = "Support"
  },
  {
    id      = "suporte-01"
    user    = "suporte"
    display = "Suporte"
  },
  {
    id      = "teste-01"
    user    = "teste"
    display = "Teste"
  }]