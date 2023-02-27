provider "aws" {
  region = "sa-east-1"
}

terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "olga_production_bucket" {
  bucket = "olga-production-bucket"
}

resource "aws_s3_bucket_policy" "olga_production_bucket_policy" {
  bucket = aws_s3_bucket.olga_production_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.olga_production_bucket.arn}/*"
        ]
      }
    ]
  })
}
