# s3.tf

resource "aws_s3_bucket" "workspace" {
  bucket = "${var.campaign_prefix}-${var.campaign_name}-workspace"

  tags = {
    Name        = "${var.campaign_prefix}-${var.campaign_name}-workspace"
  }
}

resource "aws_s3_bucket_acl" "workspace" {
  bucket = aws_s3_bucket.workspace.id
  acl    = "private"
}