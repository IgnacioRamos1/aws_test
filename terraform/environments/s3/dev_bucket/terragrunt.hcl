# Terragrunt configuration that defines the variables specific to the dev_bucket environment

# Include the common variables defined in the root terragrunt.hcl file
include {
  path = "${find_in_parent_folders()}"
}

# Define input variables specific to the dev_bucket environment
inputs = {
  bucket_name = "olga-develop-bucket"
  environment = "dev"
}
