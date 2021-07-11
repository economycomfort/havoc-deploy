# outputs.tf

output "campaign_id" {
  value = "${var.campaign_prefix}-${var.campaign_name}"
}

output "campaign_server" {
  value = var.enable_domain_name ? "https://${var.campaign_prefix}-${var.campaign_name}.${var.domain_name}" : "A campaign server was not provisioned because a domain name was not provided"
}

output "campaign_server_username" {
  value = var.enable_domain_name ? "admin" : null
}

output "campaign_server_password" {
  value = var.enable_domain_name ? "admin" : null
}

output "campaign_admin_email" {
  value = var.campaign_admin_email
}

output "api_domain_name" {
  value = var.enable_domain_name ? "${var.campaign_prefix}-${var.campaign_name}-api.${var.domain_name}" : "${aws_api_gateway_rest_api.rest_api.id}.execute-api.${var.aws_region}.amazonaws.com"
}

output "api_region" {
  value = var.aws_region
}

output "api_key" {
  value = random_string.api_key.id
}

output "secret" {
  value = random_string.secret.id
}