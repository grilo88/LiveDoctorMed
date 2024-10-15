module "www" {
  source     = "../../../../modules/aws-cloud/www"
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  project    = var.www_project
  domain     = var.domain
  subdomain  = var.www_subdomain
}

module "meet" {
  source            = "../../../../modules/aws-cloud/meet"
  region            = var.region
  access_key        = var.access_key
  secret_key        = var.secret_key
  project           = var.meet_project
  domain            = var.domain
  subdomain         = var.meet_subdomain
  base_ami_id       = var.meet_base_ami_id
  web_instance_type = var.meet_web_instance_type
}

module "mail" {
  source            = "../../../../modules/aws-cloud/mail"
  region            = var.region
  organization      = var.organization
  access_key        = var.access_key
  secret_key        = var.secret_key
  project           = var.meet_project
  domain            = var.domain
  subdomain         = var.meet_subdomain
}

module "route-meet-to-us-east-1" {
  source            = "../../../../modules/aws-cloud/meet/route-to-us-east-1"
  region            = var.region
  access_key        = var.access_key
  secret_key        = var.secret_key
  meet_project      = var.meet_project
  domain            = var.domain
  meet_subdomain    = var.meet_subdomain
  meet_base_ami_id  = var.meet_base_ami_id
  meet_web_instance_type = var.meet_web_instance_type
  aws_lb_app_lb_dns_name = module.meet.aws_lb_app_lb_dns_name
  aws_lb_app_lb_zone_id = module.meet.aws_lb_app_lb_zone_id
}