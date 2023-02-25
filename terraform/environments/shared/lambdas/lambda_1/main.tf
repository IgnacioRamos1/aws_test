provider "aws" {
  region = "sa-east-1"
}

data "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-lambda_1"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../../../../../lambdas/testing2/main"
  output_path = "/tmp/main.zip"
}


data "aws_s3_bucket" "lambda_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_object" "lambda_zip" {
  bucket       = data.aws_s3_bucket.lambda_bucket.id
  key          = "${var.s3_key}/${var.function_name}.zip"
  source       = data.archive_file.lambda_zip.output_path
  content_type = "application/zip"
}


module "lambda" {
  source        = "../../../../modules/lambda"
  function_name = "lambda_1"
  handler       = "main"
  runtime       = "go1.x"
  filename      = data.archive_file.lambda_zip.output_path
  role          = data.aws_iam_role.lambda_exec.arn
}

resource "aws_api_gateway_rest_api" "lambda_api" {
  name = "lambda-api"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.lambda_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.invoke_arn
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name =  module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:sa-east-1:123456789012:${aws_api_gateway_rest_api.lambda_api.id}/*/*"
}


