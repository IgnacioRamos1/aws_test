provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "olga_develop_bucket" {
  bucket = "qq08q3ur0q8ufjdc08q3"
}

resource "aws_s3_bucket_policy" "olga_develop_bucket_policy" {
  bucket = aws_s3_bucket.olga_develop_bucket.id

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
          "${aws_s3_bucket.olga_develop_bucket.arn}/*"
        ]
      }
    ]
  })
}

terraform {
  backend "s3" {}
}
