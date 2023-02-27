resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  handler = var.handler
  runtime = var.runtime
  filename = var.filename
  role = var.role
}

data "aws_iam_role" "lambda_exec" {
  name = "lambda-exec"
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_function.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.lambda_function.function_name
}

output "lambda_role" {
  value = data.aws_iam_role.lambda_exec.arn
}
