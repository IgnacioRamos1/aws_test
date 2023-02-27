provider "aws" {
  region = "sa-east-1"
}

data "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-test"
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

module "api_gateway" {
  source     = "../../../modules/api_gateway"
  endpoint   = var.endpoint
  http_method = var.http_method
  lambda_invoke_arn = module.lambda.invoke_arn
  function_name = var.function_name
}

output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}
