locals {
  s3_origin_id = aws_s3_bucket.website.bucket_regional_domain_name
}

resource "aws_cloudfront_distribution" "website" {
  aliases             = var.subdomain == "www" ? ["${var.domain}", "${var.subdomain}.${var.domain}"] : ["${var.subdomain}.${var.domain}"]
  comment             = var.subdomain
  default_root_object = "index.html"

  enabled         = true
  is_ipv6_enabled = true

  origin {
    connection_attempts = 3
    connection_timeout  = 10

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2", "SSLv3", "TLSv1", "TLSv1.1"]
    }

    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["HEAD", "OPTIONS", "GET"]
    target_origin_id = local.s3_origin_id
    compress         = true
    smooth_streaming = false

    # Lambda@Edge associado ao evento 'origin-request'
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = "${aws_lambda_function.lambda_edge.arn}:${aws_lambda_function.lambda_edge.version}"
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class      = "PriceClass_All"
  retain_on_delete = false
  staging          = false

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "BR"]
    }
  }

  tags = {
    Environment = "${var.project}"
  }

  viewer_certificate {
    acm_certificate_arn            = module.certificate.aws_acm_certificate_cert_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}