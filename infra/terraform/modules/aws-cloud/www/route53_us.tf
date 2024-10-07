resource "aws_route53_record" "root_us" {
  count = var.subdomain == "www" ? 1 : 0 # Se o domínio for "www", cria o domínio root

  zone_id = local.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = true
  }

  set_identifier = "${var.region}-us-geolocation"
  geolocation_routing_policy {
    country   = "US"
  }
}

resource "aws_route53_record" "www_us" {
  zone_id = local.zone_id
  name    = "${var.subdomain}.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = true
  }

  set_identifier = "${var.region}-us-geolocation"
  geolocation_routing_policy {
    country   = "US"
  }
}