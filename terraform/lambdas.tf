# lambdas.tf

data "aws_s3_bucket_object" "authorizer_hash" {
  bucket = "havoc-control-api"
  key    = "authorizer.zip.base64sha256"
}

data "aws_s3_bucket_object" "manage_hash" {
  bucket = "havoc-control-api"
  key    = "manage.zip.base64sha256"
}

data "aws_s3_bucket_object" "remote_task_hash" {
  bucket = "havoc-control-api"
  key    = "remote_task.zip.base64sha256"
}

data "aws_s3_bucket_object" "task_control_hash" {
  bucket = "havoc-control-api"
  key    = "task_control.zip.base64sha256"
}

data "aws_s3_bucket_object" "task_result_hash" {
  bucket = "havoc-control-api"
  key    = "task_result.zip.base64sha256"
}

resource "aws_lambda_function" "authorizer" {
  function_name = "${var.campaign_prefix}-${var.campaign_name}-authorizer"

  s3_bucket = "havoc-control-api"
  s3_key    = "authorizer.zip"
  source_code_hash = data.aws_s3_bucket_object.authorizer_hash.body

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CAMPAIGN_ID     = "${var.campaign_prefix}-${var.campaign_name}"
      API_DOMAIN_NAME = "${var.campaign_prefix}-${var.campaign_name}-api.${var.domain_name}"
    }
  }
}

resource "aws_lambda_function" "manage" {
  function_name = "${var.campaign_prefix}-${var.campaign_name}-manage"

  s3_bucket = "havoc-control-api"
  s3_key    = "manage.zip"
  source_code_hash = data.aws_s3_bucket_object.manage_hash.body

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CAMPAIGN_ID = "${var.campaign_prefix}-${var.campaign_name}"
      VPC_ID = aws_vpc.campaign_vpc.id
    }
  }
}

resource "aws_lambda_permission" "apigw_manage_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "remote_task" {
  function_name = "${var.campaign_prefix}-${var.campaign_name}-remote-task"

  s3_bucket = "havoc-control-api"
  s3_key    = "remote_task.zip"
  source_code_hash = data.aws_s3_bucket_object.remote_task_hash.body

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CAMPAIGN_ID = "${var.campaign_prefix}-${var.campaign_name}"
    }
  }
}

resource "aws_lambda_permission" "apigw_remote_task_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remote_task.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "task_control" {
  function_name = "${var.campaign_prefix}-${var.campaign_name}-task-control"

  s3_bucket = "havoc-control-api"
  s3_key    = "task_control.zip"
  source_code_hash = data.aws_s3_bucket_object.task_control_hash.body

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  timeout = 30

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CAMPAIGN_ID = "${var.campaign_prefix}-${var.campaign_name}"
      SUBNET = aws_subnet.campaign_subnet.id
    }
  }
}

resource "aws_lambda_permission" "apigw_task_control_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.task_control.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "task_result" {
  function_name = "${var.campaign_prefix}-${var.campaign_name}-task-result"

  s3_bucket = "havoc-control-api"
  s3_key    = "task_result.zip"
  source_code_hash = data.aws_s3_bucket_object.task_result_hash.body

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CAMPAIGN_ID = "${var.campaign_prefix}-${var.campaign_name}"
    }
  }
}

resource "aws_lambda_permission" "cwlogs_task_result_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.task_result.function_name
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn = "${aws_cloudwatch_log_group.ecs_task_logs.arn}:*"
}