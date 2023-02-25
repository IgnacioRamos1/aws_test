variable "http_method" {
  description = "The HTTP method for the API Gateway resource."
  type        = string
  default     = "GET"
}

variable "endpoint" {
  description = "The endpoint for the API Gateway resource."
  type        = string
  default     = "lambda_1"
}

variable "stage_name" {
  description = "The name of the stage to deploy the API Gateway resource to."
  type        = string
  default     = "dev"
}

