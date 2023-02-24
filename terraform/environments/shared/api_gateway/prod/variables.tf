variable "name" {
  type    = string
  default = "prod-api-gateway"
}

variable "description" {
  type    = string
  default = "Production API Gateway"
}

variable "stage_name" {
  type    = string
  default = "prod"
}

variable "variables" {
  type    = map(string)
  default = {}
}
