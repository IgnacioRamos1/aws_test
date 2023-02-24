module "s3_bucket" {
  source = "../../../../modules/s3_bucket"
  bucket_name = var.bucket_name
  region = var.region
  access_policy = var.access_policy
}
