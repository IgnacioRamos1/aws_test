resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  handler = var.handler
  runtime = var.runtime
  filename = var.filename
  role = aws_iam_role.lambda_exec.arn
}

