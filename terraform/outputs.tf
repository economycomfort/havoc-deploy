# outputs.tf

output "campaign_server" {
  value = "https://${var.campaign_prefix}-${var.campaign_name}.${data.aws_route53_zone.selected.name}"
}

output "campaign_server_username" {
  value = "admin"
}

output "campaign_server_password" {
  value = "admin"
}

output "campaign_api_base_url" {
  value = aws_api_gateway_deployment.rest_api.invoke_url
}

output "campaign_admin_email" {
  value = var.campaign_admin_email
}

output "campaign_admin_api_key" {
  value = random_string.api_key.id
}

output "campaign_admin_secret" {
  value = random_string.secret.id
}