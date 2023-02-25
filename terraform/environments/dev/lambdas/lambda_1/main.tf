resource "aws_lambda_function" "lambda_1" {
  function_name = "lambda_1"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "../../../../lambdas/lambda1/lambda1.zip"
}
