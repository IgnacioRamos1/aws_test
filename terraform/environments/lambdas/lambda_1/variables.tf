variable "function_name" {
  description = "The name of the Lambda function to invoke."
  type        = string
  default     = "lambda_1"
}

variable s3_bucket_name {
  description = "The name of the S3 bucket to store the API Gateway resource."
  type        = string
  default     = "olga-develop-bucket-12"
}

variable "s3_key" {
  description = "The name of the S3 key to store the API Gateway resource."
  type        = string
  default     = "Lambda 1 Binary"
}
variable "http_method" {
  description = "The HTTP method for the API Gateway resource."
  type        = string
  default     = "GET"
}

variable "endpoint" {
  description = "The endpoint for the API Gateway resource."
  type        = string
  default     = "lambda"
}
