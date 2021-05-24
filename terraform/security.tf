# security.tf

# Project Server Security Group: Edit to restrict access to the campaign server
resource "aws_security_group" "campaign_server_group" {
  name        = "${var.campaign_prefix}-${var.campaign_name}-campaign-server"
  description = "controls access to the Havoc campaign server"
  vpc_id      = aws_vpc.campaign_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.http_port
    to_port     = var.http_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  protocol    = "tcp"
  from_port   = var.https_port
  to_port     = var.https_port
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  protocol    = "tcp"
  from_port   = var.ssh_port
  to_port     = var.ssh_port
  cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
