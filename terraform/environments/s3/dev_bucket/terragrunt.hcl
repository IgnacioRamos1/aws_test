# Terragrunt configuration that defines the variables specific to the dev_bucket environment

# Include the common variables defined in the root terragrunt.hcl file
include {
  path = "${find_in_parent_folders()}"
}

# Define input variables specific to the dev_bucket environment
inputs = {
  bucket_name = "qq08q3ur0q8ufjdc08q3"
  environment = "dev"
}
