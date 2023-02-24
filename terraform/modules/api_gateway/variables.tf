variable "name" {
  description = "The name of the API Gateway."
  type        = string
}

variable "root_resource_path" {
  description = "The path of the root resource."
  type        = string
}

variable "http_method" {
  description = "The HTTP method to be used in the API Gateway."
  type        = string
}

variable "authorization" {
  description = "The authorization method to be used in the API Gateway."
  type        = string
}

variable "stage_name" {
  description = "The name of the deployment stage."
  type        = string
}
