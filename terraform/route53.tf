# route53.tf

resource "aws_route53_record" "campaign_server_record" {
  count   = var.enable_domain_name ? 1 : 0
  zone_id = var.hosted_zone
  name    = "${var.campaign_prefix}-${var.campaign_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.campaign_server_eip.public_ip[count.index]]
}

resource "aws_route53_record" "campaign_api_cert_validation" {
  count           = var.enable_domain_name ? 1 : 0
  allow_overwrite = true
  name            = aws_acm_certificate.api_gateway_cert.resource_record_name[count.index]
  records         = [aws_acm_certificate.api_gateway_cert.resource_record_value[count.index]]
  ttl             = 60
  type            = aws_acm_certificate.api_gateway_cert.resource_record_type[count.index]
  zone_id         = var.hosted_zone
}

resource "aws_route53_record" "campaign_api_record" {
  count   = var.enable_domain_name ? 1 : 0
  name    = "${var.campaign_prefix}-${var.campaign_name}-api.${var.domain_name}"
  type    = "A"
  zone_id = var.hosted_zone

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.rest_api.regional_domain_name[count.index]
    zone_id                = aws_api_gateway_domain_name.rest_api.regional_zone_id[count.index]
  }
}
