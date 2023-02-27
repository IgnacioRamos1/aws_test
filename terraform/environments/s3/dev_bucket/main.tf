provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "olga_develop_bucket" {
  bucket = "olga-develop-bucket-12"
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
