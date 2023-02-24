variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "olgaproduction"
}

variable "region" {
  description = "The AWS region in which to create the S3 bucket."
  type        = string
  default     = "sa-east-1"
}

variable "access_policy" {
  description = "The policy that controls access to the S3 bucket."
  type        = string
}
