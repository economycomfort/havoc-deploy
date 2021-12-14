# ecs.tf

resource "aws_ecs_cluster" "cluster" {
  name = "${var.campaign_prefix}-${var.campaign_name}-cluster"
}

data "template_file" "nmap_task_definition" {
  template = file("templates/nmap_task_definition.template")

  vars = {
  campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "nmap" {
  family                = "nmap"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  container_definitions = data.template_file.nmap_task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  tags                     = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
    name        = "nmap"
  }
}

data "template_file" "metasploit_task_definition" {
  template = file("templates/metasploit_task_definition.template")

  vars = {
  campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "metasploit" {
  family                = "metasploit"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  container_definitions = data.template_file.metasploit_task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  tags                     = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
    name        = "metasploit"
  }
}

data "template_file" "powershell_empire_task_definition" {
  template = file("templates/powershell_empire_task_definition.template")

  vars = {
  campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "powershell_empire" {
  family                = "powershell_empire"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  container_definitions = data.template_file.powershell_empire_task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  tags                     = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
    name        = "powershell_empire"
  }
}

data "template_file" "http_server_task_definition" {
  template = file("templates/http_server_task_definition.template")

  vars = {
  campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "http_server" {
  family                = "http_server"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  container_definitions = data.template_file.http_server_task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  tags                     = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
    name        = "http_server"
  }
}

data "template_file" "trainman_task_definition" {
  template = file("templates/trainman_task_definition.template")

  vars = {
  campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "trainman" {
  family                = "trainman"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  container_definitions = data.template_file.trainman_task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  tags                     = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
    name        = "trainman"
  }
}

data "template_file" "exfilkit_task_definition" {
  template = file("templates/exfilkit_task_definition.template")

  vars = {
  campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
  aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "exfilkit" {
  family                = "exfilkit"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  network_mode          = "awsvpc"
  container_definitions = data.template_file.exfilkit_task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  tags                     = {
    campaign_id = "${var.campaign_prefix}-${var.campaign_name}"
    name        = "exfilkit"
  }
}