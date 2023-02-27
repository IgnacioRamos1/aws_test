variable "endpoint" {
  description = "The endpoint for the API Gateway resource."
  type        = string
}

variable "http_method" {
  description = "The HTTP method used by the API Gateway method"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The ARN of the Lambda function to be invoked by the API Gateway method"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function to invoke."
  type        = string
}
