provider "aws" {
  region = "sa-east-1"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-test"
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

output "name" {
  value = aws_iam_role.lambda_exec.name  
}
