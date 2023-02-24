variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket."
}

variable "region" {
  type        = string
  description = "AWS region where the S3 bucket should be created."
}

variable "access_policy" {
  type        = map
  description = "Policy to apply to the S3 bucket."
  default     = {}
}

variable "prevent_destroy" {
  type        = bool
  description = "Prevent the S3 bucket from being destroyed."
  default     = false
}
