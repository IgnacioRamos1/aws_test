variable "name" {
  type    = string
  default = "dev-api-gateway"
}

variable "description" {
  type    = string
  default = "Development API Gateway"
}

variable "stage_name" {
  type    = string
  default = "dev"
}

variable "variables" {
  type    = map(string)
  default = {}
}
