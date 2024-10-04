provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  retry_mode = "adaptive"  # "legacy" or "standard"
}

data "local_file" "route53_zone_id" {
  filename = "${path.module}/../../../../route53_zone_id.txt"
}

locals {
  zone_id = data.local_file.route53_zone_id.content
}