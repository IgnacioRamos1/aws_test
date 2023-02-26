# Terragrunt configuration that defines the variables specific to the lambda1 environment

# Include the common variables defined in the root terragrunt.hcl file
include {
  path = "${find_in_parent_folders()}"
}

# Define input variables specific to the lambda1 environment
inputs = {
  lambda_name = "my-lambda1"
  environment = "lambda1"
}
