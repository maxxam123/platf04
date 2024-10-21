
data "archive_file" "Lambda_zip_file" {
  type        = "zip"
  source_file = "Lambda/index.js"
  output_path = "Lambda/index.zip"
}

resource "aws_iam_role" "Lambda_role" {
  assume_role_policy = file("lambda-policy.json")
  # name = "test_role"
  name = var.role
}

resource "aws_iam_role_policy_attachment" "Lambda_exec_role_attachment" {
  role       = aws_iam_role.Lambda_role.arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "yt_lambda_function" {
  # function_name = "lambda_function_name"
  function_name = var.function
  filename      = "Lambda/index.js"
  role          = aws_iam_role.Lambda_role.arn
  handler       = "index.handler"
  #vruntime = "nodejs20.x"
  runtime = var.runtime
  timeout = 30
  source_code_hash = data.archive_file.Lambda_zip_file.output_base64sha256

  environment {
    variables = {
      VIDEO_NAME = "Lambda Terraform Demo"
      # var.VALULE = var.MSG
    }
  }
}


resource "aws_api_gateway_rest_api" "yt_api" {
  # name = "example-rest-api"
  name = var.gateway
  description = "test"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "yt_api_resource" {
  parent_id   = aws_api_gateway_rest_api.yt_api.root_resource_id
  # path_part   = "demo-paht"
  path_part = var.path
  rest_api_id = aws_api_gateway_rest_api.yt_api.id
}

resource "aws_api_gateway_method" "yt_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.yt_api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.yt_api.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
    http_method = aws_api_gateway_method.yt_method.http_method
    resource_id = aws_api_gateway_resource.yt_api_resource.id
    rest_api_id = aws_api_gateway_rest_api.yt_api.id
    type = "AWS_PROXY"
    integration_http_method = "POST"
    uri = aws_lambda_function.yt_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.yt_api.id
  stage_name = "dev"

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.yt_api_resource.id,
      aws_api_gateway_method.yt_method.id,
      aws_api_gateway_integration.lambda_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.yt_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"
  source_arn    = "${aws_api_gateway_rest_api.yt_api.execution_arn}/*/*/*"
}

output "invoke_url" {
  value       = aws_api_gateway_deployment.api_deployment.invoke_url
}

