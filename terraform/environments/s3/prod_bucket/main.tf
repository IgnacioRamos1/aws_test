provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "olga_productionop_bucket" {
  bucket = "olga-productionop-bucket"
}

resource "aws_s3_bucket_policy" "olga_productionop_bucket_policy" {
  bucket = aws_s3_bucket.olga_productionop_bucket.id

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
          "${aws_s3_bucket.olga_productionop_bucket.arn}/*"
        ]
      }
    ]
  })
}
