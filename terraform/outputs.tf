# outputs.tf

output "campaign_id" {
  value = "${var.campaign_prefix}-${var.campaign_name}"
}

output "campaign_server" {
  value = "https://${var.campaign_prefix}-${var.campaign_name}.${data.aws_route53_zone.selected.name}"
}

output "campaign_server_username" {
  value = "admin"
}

output "campaign_server_password" {
  value = "admin"
}

output "campaign_admin_email" {
  value = var.campaign_admin_email
}

output "api_domain_name" {
  value = "${var.campaign_prefix}-${var.campaign_name}-api.${var.domain_name}"
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