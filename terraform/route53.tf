# route53.tf

resource "aws_route53_record" "campaign_server_record" {
  count   = var.enable_domain_name ? 1 : 0
  zone_id = var.hosted_zone
  name    = "${var.campaign_prefix}-${var.campaign_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.campaign_server_eip.public_ip]
}

resource "aws_route53_record" "campaign_api_cert_validation" {
  count    = var.enable_domain_name ? 1 : 0
  for_each = {
    for dvo in aws_acm_certificate.api_gateway_cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.hosted_zone
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_route53_record" "campaign_api_record" {
  count   = var.enable_domain_name ? 1 : 0
  name    = "${var.campaign_prefix}-${var.campaign_name}-api.${var.domain_name}"
  type    = "A"
  zone_id = var.hosted_zone

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.rest_api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.rest_api.regional_zone_id
  }
}
