# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in."
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile to be used by Terraform."
  default     = "default"
}

# This value will be used in the name of several S3 buckets so it must be DNS compliant (https://datatracker.ietf.org/doc/html/rfc952).
variable "campaign_prefix" {
  description = "The prefix added to the name of resources created for your havoc campaign."
  default     = "havoc"
}

# This value will be used in the name of several S3 buckets so it must be DNS compliant (https://datatracker.ietf.org/doc/html/rfc952).
variable "campaign_name" {
  description = "The name appended to the campaign_prefix for naming resources created for your havoc campaign."
  default     = "my-campaign"
}

variable "enable_domain_name" {
  description = "If set to true, the havoc campaign API endpoint will be deployed with a friendly DNS name as defined by the hosted_zone and domain_name variables."
  type        = bool
}

variable "hosted_zone" {
  description = "The ID of the hosted zone from which your campaign API endpoint will derive its DNS name."
  default     = null
}

variable "domain_name" {
  description = "The domain name that will be assigned to your campaign API, i.e. example.com."
  default     = null
}

variable "campaign_admin_email" {
  description = "The email address that will be the username for the campaign admin."
}

variable "results_queue_expiration" {
  description = "The number of days to keep task results in the queue."
  default     = 30
}