provider "aws" {
  region = "sa-east-1"
}

terraform {
  backend "s3" {}
}

module "iam" {
  source = "../../iam"
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
  role          = module.lambda.lambda_role
}

module "api_gateway" {
  source    = "../../../modules/api_gateway"
  endpoint  = var.endpoint

  lambdas = {
    test = {
      arn          = module.lambda.invoke_arn
      http_method  = "GET"
      resource     = "/test"
    },
    hello = {
      arn          = module.lambda.invoke_arn
      http_method  = "POST"
      resource     = "/hello"
    }
  }
}
