# ec2.tf

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_route53_zone" "selected" {
  zone_id         = var.hosted_zone
}

data "template_file" "user_data" {
  template = file("templates/build_server.yaml")

  vars = {
  region             = var.aws_region
  campaign_id         = "${var.campaign_prefix}-${var.campaign_name}"
  logstash_config    = var.logstash_config
  letsencrypt_email  = var.campaign_admin_email
  letsencrypt_host   = "${var.campaign_prefix}-${var.campaign_name}.${data.aws_route53_zone.selected.name}"
  }
}

resource "aws_instance" "campaign_server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.large"
  key_name             = var.keypair
  subnet_id            = aws_subnet.campaign_subnet.id
  security_groups      = [aws_security_group.campaign_server_group.id]
  iam_instance_profile = aws_iam_instance_profile.campaign_server_profile.name
  user_data            = data.template_file.user_data.rendered

  tags = {
    Name = "${var.campaign_prefix}-${var.campaign_name}"
  }
}

resource "aws_eip" "campaign_server_eip" {
  instance   = aws_instance.campaign_server.id
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}