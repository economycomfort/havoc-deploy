# outputs.tf

output "CAMPAIGN_ID" {
  value = "${var.campaign_prefix}-${var.campaign_name}"
}

output "CAMPAIGN_ADMIN_EMAIL" {
  value = var.campaign_admin_email
}

output "API_DOMAIN_NAME" {
  value = var.enable_domain_name ? "${var.campaign_name}-api.${var.domain_name}" : "${aws_api_gateway_rest_api.rest_api.id}.execute-api.${var.aws_region}.amazonaws.com"
}

output "API_REGION" {
  value = var.aws_region
}

output "API_KEY" {
  value = "${random_string.api_key.id}"
}

output "SECRET" {
  value = "${random_string.secret.id}"
}