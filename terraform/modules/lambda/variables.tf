variable "function_name" {
  type = string
}

variable "handler" {
  type = string
  default = "main"
}

variable "runtime" {
  type = string
  default = "go1.x"
}

variable "filename" {
  type = string
}

variable "role_arn" {
  type = string
}

