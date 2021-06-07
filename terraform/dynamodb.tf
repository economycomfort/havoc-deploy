# dynamodb.tf

resource "random_string" "api_key" {
  length = 12
  special = false
}

resource "random_string" "secret" {
  length  = 24
  special = true
}

resource "aws_dynamodb_table_item" "campaign_admin" {
  table_name = aws_dynamodb_table.authorizer.name
  hash_key   = aws_dynamodb_table.authorizer.hash_key

  item = <<ITEM
{
  "api_key": {
    "S": "${random_string.api_key.id}"
  },
  "secret_key": {
    "S": "${random_string.secret.id}"
  },
  "user_id": {
    "S": "${var.campaign_admin_email}"
  },
  "admin": {
    "S": "yes"
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "nmap_task_type" {
  table_name = aws_dynamodb_table.task_types.name
  hash_key   = aws_dynamodb_table.task_types.hash_key

  item = <<ITEM
{
  "task_type": {
    "S": "nmap"
  },
  "capabilities": {
    "SS": ${jsonencode(["run_scan","get_scan_info","get_scan_results","echo"])}
  },
  "source_image": {
    "S": "public.ecr.aws/havoc_sh/nmap:latest"
  },
  "cpu": {
    "N": "512"
  },
  "memory": {
    "N": "1024"
  },
  "created_by": {
    "S": "${var.campaign_admin_email}"
  }
}
ITEM
}

resource "aws_dynamodb_table_item" "metasploit_task_type" {
  table_name = aws_dynamodb_table.task_types.name
  hash_key   = aws_dynamodb_table.task_types.hash_key

  item = <<ITEM
{
  "task_type": {
    "S": "metasploit"
  },
  "capabilities": {
    "SS": ${jsonencode(["list_exploits","list_payloads","list_jobs","list_sessions","set_exploit_module","set_exploit_options","set_exploit_target","set_payload_module","set_payload_options","show_exploit","show_exploit_options","show_exploit_option_info","show_exploit_targets","show_exploit_evasion","show_exploit_payloads","show_configured_exploit_options","show_exploit_requirements","show_missing_exploit_requirements","show_last_exploit_results","show_payload","show_payload_options","show_payload_option_info","show_configured_payload_options","show_payload_requirements","show_missing_payload_requirements","show_job_info","show_session_info","execute_exploit","generate_payload","run_session_command","run_session_shell_command","session_tabs","load_session_plugin","session_import_psh","session_run_psh_cmd","run_session_script","get_session_writeable_dir","session_read","detach_session","kill_session","kill_job","echo"])}
  },
  "source_image": {
    "S": "public.ecr.aws/havoc_sh/metasploit:latest"
  },
  "cpu": {
    "N": "1024"
  },
  "memory": {
    "N": "4096"
  },
  "created_by": {
    "S": "${var.campaign_admin_email}"
  }
}
ITEM
}

resource "aws_dynamodb_table" "authorizer" {
  name           = "${var.campaign_prefix}-${var.campaign_name}-authorizer"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "api_key"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name               = "${var.campaign_prefix}-${var.campaign_name}-ApiKeyIndex"
    hash_key           = "api_key"
    projection_type    = "ALL"
  }
}

resource "aws_dynamodb_table" "portgroups" {
  name           = "${var.campaign_prefix}-${var.campaign_name}-portgroups"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "portgroup_name"

  attribute {
    name = "portgroup_name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "task_types" {
  name           = "${var.campaign_prefix}-${var.campaign_name}-task-types"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "task_type"

  attribute {
  name = "task_type"
  type = "S"
  }
}

resource "aws_dynamodb_table" "tasks" {
  name           = "${var.campaign_prefix}-${var.campaign_name}-tasks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "task_name"

  attribute {
  name = "task_name"
  type = "S"
  }
}

resource "aws_dynamodb_table" "queue" {
  name           = "${var.campaign_prefix}-${var.campaign_name}-queue"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "task_name"
  range_key      = "run_time"

  attribute {
    name = "task_name"
    type = "S"
  }

  attribute {
  name = "run_time"
  type = "N"
  }

  ttl {
  attribute_name = "run_time"
  enabled        = true
  }
}
