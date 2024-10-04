terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  retry_mode = "adaptive"  # "legacy" or "standard"
}

data "local_file" "route53_zone_id" {
  filename = "${path.module}/../../../route53_zone_id.txt"
}

locals {
  zone_id = data.local_file.route53_zone_id.content
}

module "certificate" {
  source     = "./certificate"
  access_key = var.access_key
  secret_key = var.secret_key
  project    = var.project
  domain     = var.domain
  subdomain  = var.subdomain
}