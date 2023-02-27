# Terragrunt configuration that defines the backend to use for storing the Terraform state files
# and the common variables that can be used across all environments

remote_state {
  backend = "s3"
  config = {
    bucket = "qq08q3ur0q8ufjdc08q3"
    key    = "terraform.tfstate"
    region = "sa-east-1"
  }
}
