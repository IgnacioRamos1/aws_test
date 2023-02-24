resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  handler = var.handler
  runtime = var.runtime
  filename = var.filename
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-${var.function_name}"
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
