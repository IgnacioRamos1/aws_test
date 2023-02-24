resource "aws_s3_bucket_policy" "bucket_policy" {
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::${bucket_name}"
        ]
      },
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource": [
          "arn:aws:s3:::${bucket_name}/*"
        ]
      }
    ]
  }
POLICY
  bucket = aws_s3_bucket.bucket.id
}
