resource "aws_route53_record" "meet_sa" {
  zone_id = local.zone_id
  name    = "${var.meet_subdomain}.${var.domain}"
  type    = "A"

  alias {
    name                   = var.aws_lb_app_lb_dns_name
    zone_id                = var.aws_lb_app_lb_zone_id
    evaluate_target_health = true
  }

  set_identifier = "${var.region}-geolocation"
  geolocation_routing_policy {
    country   = "BR" # Brasil
  }
}