provider "aws" {
  region = "sa-east-1"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  handler = var.handler
  runtime = var.runtime
  filename = var.filename
  role = var.role
}