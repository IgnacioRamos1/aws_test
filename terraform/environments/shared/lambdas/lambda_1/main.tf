provider "aws" {
  region = "sa-east-1"
}

data "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-lambda_1"
}

output "role_arn" {
  value = data.aws_iam_role.lambda_exec.arn
}

module "lambda" {
  source        = "../../../../modules/lambda"
  function_name = "lambda_1"
  handler       = "main"
  runtime       = "go1.x"
  filename      = "../../../../../lambdas/testing2/main.zip"
  role          = data.aws_iam_role.lambda_exec.arn
}


# ------------------- API GATEWAY -------------------
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "my_api_gateway"
}

resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "test"
}

resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.invoke_arn

  request_parameters = {
    "integration.request.header.X-Amz-Invocation-Type" = "'Event'"
  }
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name = "dev"
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
}
