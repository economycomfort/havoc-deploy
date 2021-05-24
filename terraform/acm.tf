# acm.tf

resource "aws_acm_certificate" "api_gateway_cert" {
  domain_name       = "${var.campaign_prefix}-${var.campaign_name}-api.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api_gateway_cert" {
  certificate_arn         = aws_acm_certificate.api_gateway_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.campaign_api_cert_validation : record.fqdn]
}