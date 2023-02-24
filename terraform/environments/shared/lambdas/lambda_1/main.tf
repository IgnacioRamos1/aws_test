locals {
  lambda_zip_file = "${path.module}/../../../../builds/lambdas/lambda_1.zip"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${path.module}/../../../../lambdas/testing2"
  output_path = local.lambda_zip_file
}

resource "aws_s3_bucket_object" "lambda_zip" {
  key    = "lambda_1.zip"
  bucket = module.s3_bucket.bucket_id
  source = local.lambda_zip_file
}

resource "aws_lambda_function" "lambda_1" {
  function_name = "lambda_1"
  handler       = "index.handler"
  runtime       = "go1.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = aws_s3_bucket_object.lambda_zip.id
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = module.api_gateway.rest_api_execution_arn
}

resource "aws_api_gateway_resource" "lambda_1_resource" {
  parent_id   = module.api_gateway.rest_api_root_resource_id
  path_part   = "lambda_1"
  rest_api_id = module.api_gateway.rest_api_id
}

resource "aws_api_gateway_method" "lambda_1_method" {
  rest_api_id   = module.api_gateway.rest_api_id
  resource_id   = aws_api_gateway_resource.lambda_1_resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_1_integration" {
  rest_api_id             = module.api_gateway.rest_api_id
  resource_id             = aws_api_gateway_resource.lambda_1_resource.id
  http_method             = var.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_1.invoke_arn
}

resource "aws_api_gateway_deployment" "lambda_1_deployment" {
  rest_api_id = module.api_gateway.rest_api_id
  stage_name  = var.stage_name
  triggers = {
    redeployment = sha1(join(",", [
      aws_lambda_function.lambda_1.arn,
      aws_api_gateway_method.lambda_1_method.http_method,
      aws_api_gateway_resource.lambda_1_resource.path_part,
      aws_api_gateway_integration.lambda_1_integration.uri
    ]))
  }
}
