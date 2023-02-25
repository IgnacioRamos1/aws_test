provider "aws" {
  region = "sa-east-1"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-lambda_1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

output "role_arn" {
  value = aws_iam_role.lambda_exec.arn
}

module "lambda" {
  source        = "../../../../modules/lambda"
  function_name = "lambda_1"
  handler       = "main"
  runtime       = "go1.x"
  filename      = "../../../../../lambdas/testing2/main.zip"
  role          = aws_iam_role.lambda_exec.arn
}
