# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile to be used by Terraform"
  default     = "default"
}

# Note that the campaign name will be used in the DNS hostname for your campaign server
# and it will also be used in the name of several S3 buckets so it must be DNS compliant (https://datatracker.ietf.org/doc/html/rfc952)
variable "campaign_prefix" {
  description = "The prefix added to the name of resources created for your havoc campaign"
  default     = "havoc"
}

# Note that the campaign name will be used in the DNS hostname for your campaign server
# and it will also be used in the name of several S3 buckets so it must be DNS compliant (https://datatracker.ietf.org/doc/html/rfc952)
variable "campaign_name" {
  description = "The name appended to the campaign_prefix for naming resources created for your havoc campaign"
  default     = "my-campaign"
}

variable "keypair" {
  description = "The name of an existing keypair to associate with your havoc campaign server"
  default     = "havoc_keypair"
}

variable "enable_domain_name" {
  description = "If set to true, the havoc campaign API endpoint and havoc campaign server will be deployed with a friendly DNS name as defined by the hosted_zone and domain_name variables"
  type        = bool
}

variable "hosted_zone" {
  description = "The ID of the hosted zone from which your campaign server and REST API will derive its DNS name"
  default     = null
}

variable "domain_name" {
  description = "The domain name that will be assigned to your campaign server and REST API, i.e. example.com"
  default     = null
}

variable "campaign_admin_email" {
  description = "The email address that will be the username for the campaign admin. This email address will also receive email notifications related to the campaign server's let's encyrpt certificate"
}

variable "results_queue_expiration" {
  description = "The number of days to keep task results in the queue"
  default     = 30
}

variable "http_port" {
  description = "HTTP port used by the campaign server"
  default     = 80
}

variable "https_port" {
  description = "HTTPS port used by the campaign server"
  default     = 443
}

variable "ssh_port" {
  description = "SSH port used by campaign server"
  default     = 22
}

variable "logstash_config" {
  description = "Contents of the campaign server's logstash.conf file"
  default     = "H4sIAIEX+GAAA7VVUU/CMBB+51c0iz4ZDdEnTTQhapQHhABvZFlmd4xqt2vaG9Es++92pUMQjASwL02/3n1f+92lFbkqiJUtxsyVmxh7Lfg7ELu9Y8FJed/pDTrdp5eo+1CdS0xTkaeBCxM5gZ7Hsg68ajsoAQkENUC6AAdpSAXmnmz4+NTtv1SLfI4J8HrjzdiAklUWrVpVqzUV0jK7w2QFxZaw9Anqs44vWTARubESnCKOWRbnSYQF2YuEE4p1ChQJFQZOdLkONgXYXgp2thB4fr/axs5W+Wt6trsIfCiJgiJUZO0z4WT43B+NR79cih1smwFjrFAk8ikuTZyhoR1sPKROCvUPiRrZ6uZeMps+DvrD8X8qrjvZrHa/516iQkVKIyFH6VVWkGOVrPEyw6SQTf9nQLFZ4H5/u1wKKJRXM1hoDj/66q8jashwDtFUgEzq1Mmur0D4H8y+nsflXq/icbm/X619eElkYCjO1Er6gtnlgIwNCW4g1ny26GHG6tfDuPxgbf/m+rLdDkL/hyTw4RrBfi1WwMzOT8uzTzsuer2LJKmatvgCgAlHzqcGAAA="
}