# Terragrunt configuration that defines the variables specific to the dev_bucket environment

# Include the common variables defined in the root terragrunt.hcl file
include {
  path = "${find_in_parent_folders()}"
}

dependencies {
  paths = [
    "../../iam",
  ]
}