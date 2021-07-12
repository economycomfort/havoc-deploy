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

data "template_file" "user_data" {
  template = file("templates/build_server.yaml")

  vars = {
  region            = var.aws_region
  campaign_id       = "${var.campaign_prefix}-${var.campaign_name}"
  logstash_config   = var.logstash_config
  letsencrypt_email = var.campaign_admin_email
  letsencrypt_host  = var.enable_domain_name ? "${var.campaign_prefix}-${var.campaign_name}.${var.domain_name}" : null
  }
}

resource "aws_instance" "campaign_server" {
  count                  = var.enable_domain_name ? 1 : 0
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.large"
  key_name               = var.keypair
  subnet_id              = aws_subnet.campaign_subnet.id
  vpc_security_group_ids = [aws_security_group.campaign_server_group.id]
  iam_instance_profile   = aws_iam_instance_profile.campaign_server_profile.name
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = "${var.campaign_prefix}-${var.campaign_name}"
  }
}

resource "aws_eip" "campaign_server_eip" {
  count      = var.enable_domain_name ? 1 : 0
  instance   = aws_instance.campaign_server[count.index].id
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_ebs_volume" "campaign_server_volume" {
  count             = var.enable_domain_name ? 1 : 0
  availability_zone = aws_instance.campaign_server[count.index].availability_zone
  type              = "gp2"
  size              = 30
}

resource "aws_volume_attachment" "campaign_server_volume_attachment" {
  count       = var.enable_domain_name ? 1 : 0
  device_name = "/dev/sdh"
  instance_id = aws_instance.campaign_server[count.index].id
  volume_id   = aws_ebs_volume.campaign_server_volume[count.index].id
}