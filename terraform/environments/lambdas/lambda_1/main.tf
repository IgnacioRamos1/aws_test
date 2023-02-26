provider "aws" {
  region = "sa-east-1"
}

data "aws_iam_role" "lambda_exec" {
  name = "lambda-exec"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../../../../lambdas/testing/main"
  output_path = "/tmp/main.zip"
}

data "aws_s3_bucket" "lambda_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_object" "lambda_zip" {
  bucket       = data.aws_s3_bucket.lambda_bucket.id
  key          = "${var.s3_key}/${var.function_name}.zip"
  source       = data.archive_file.lambda_zip.output_path
  content_type = "application/zip"
}

module "lambda" {
  source        = "../../../modules/lambda"
  function_name = var.function_name
  handler       = "main"
  runtime       = "go1.x"
  filename      = data.archive_file.lambda_zip.output_path
  role          = data.aws_iam_role.lambda_exec.arn
}

# ----------------- API Gateway -----------------

resource "aws_api_gateway_rest_api" "lambda_api" {
  name = "olga-api"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = var.endpoint
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = var.http_method
  authorization = "NONE"
} 

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.lambda_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.invoke_arn
}

resource "aws_api_gateway_integration_response" "integration_response" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method
  status_code = "200"  # o cualquier otro código de estado que quieras configurar
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method
  status_code = "200"  # o cualquier otro código de estado que quieras configurar
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name =  module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method.lambda_method,
    aws_api_gateway_resource.lambda_resource,
  ]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = "dev"
}

output "api_url" {
  value = "https://${aws_api_gateway_rest_api.lambda_api.id}.execute-api.sa-east-1.amazonaws.com/dev/lambda"
}

