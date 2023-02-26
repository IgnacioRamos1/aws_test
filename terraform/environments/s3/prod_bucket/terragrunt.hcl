# Terragrunt configuration that defines the variables specific to the prod_bucket environment

# Include the common variables defined in the root terragrunt.hcl file
include {
  path = "${find_in_parent_folders()}"
}

# Define input variables specific to the prod_bucket environment
inputs = {
  bucket_name = "ogla-production-bucket"
  environment = "prod"
}
