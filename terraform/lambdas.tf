# lambdas.tf

resource "aws_lambda_function" "authorizer" {
  function_name = "${var.campaign_prefix}-${var.campaign_name}-authorizer"

  s3_bucket = "havoc-control-api"
  s3_key    = "authorizer.zip"

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

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CAMPAIGN_ID = "${var.campaign_prefix}-${var.campaign_name}"
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

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

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