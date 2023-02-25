variable "bucket_name" {
  description = "Name of the S3 bucket to be created"
  type        = string
  default     = "olga-develop"
}

variable "region" {
  description = "Region where the S3 bucket will be created"
  type        = string
  default     = "sa-east-1"
}

