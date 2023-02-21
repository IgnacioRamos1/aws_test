terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "nachotestserverless"
    region  = "us-east-1"
    key     = "terraform.tfstate"
  }
}
