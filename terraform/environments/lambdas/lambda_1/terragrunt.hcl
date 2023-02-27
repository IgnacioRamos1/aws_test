# Terragrunt configuration that defines the variables specific to the lambda1 environment

# Include the common variables defined in the root terragrunt.hcl file
include {
  path = "${find_in_parent_folders()}"
}

dependencies {
  paths = [
    "../../s3/dev_bucket",
    "../../s3/prod_bucket",
  ]
}