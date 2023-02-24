resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  region = var.region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "policy" {
    for_each = var.policy
    content {
      policy_document = policy.value
    }
  }
}