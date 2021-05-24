# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
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

variable "hosted_zone" {
  description = "The ID of the hosted zone from which your campaign server and REST API will derive its DNS name"
  default     = "<hosted_zone_id>"
}

variable "domain_name" {
  description = "The domain name that will be assigned to your campaign server and REST API, i.e. example.com"
  default     = "example.com"
}

variable "campaign_admin_email" {
  description = "The email address that will be the username for the campaign admin. This email address will also receive email notifications related to the campaign server's let's encyrpt certificate"
  default     = "<campaign_admin_email>"
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
  default     = "H4sIAAttSGAAA62UTW/CMAyG7/0VUbWdpiE0Tpu0SWibGAc+BNxQVXWtKRlpHSUpAlX970tLyvjaoKy9VHbsx8nrxDTmiSKpRYhsFT9CPhN/AYo8vxD7Jn1t94btbqfvdt+ye4ZhSOPQLsJorEAsPZYHtpqFKwAGCnKHEgkULgEhxdjARu+d7qCfbfJ9DMDPF76kDkhJpr2ZlVnWjDJNLjYTJcrTwNQk8HUenxJ7qjy5cAVIjrEER5siBOVS7thFqa1tH2NJBS4myscIDNVYp5hkl5pDyTk0rDhDqlzkSgsknenoYzCejH85ALlSGAlSarxL4xluZZqjVBcIVV1/juIAnHtO6lUBfqzUcDCa1F9nX6vSuvxMFUpR7nKBCn1khr3j+V8rSrUiDBJW3twIdNTGb9ZPFwkBKTc1JCbCh4Nbcm5jAiJcgjujwII8dfr3W3Xq45k+1UHc704dxJ85cg1N0Qik8iK+k66J5eAG5klFfQme8Oebe0hI/sZlkW/vrT89PjSbtmMmeACrosF6sOsCcn5/m96t9dfo9RpBkJXt/gbbwESSJQYAAA=="
}