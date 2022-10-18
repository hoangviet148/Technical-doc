locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "ap-southeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/prod-terraform"
  }
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket = "hoangnv46-test-${local.account_id}"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = local.aws_region
    dynamodb_table = "hoangnv46-test-locks-${local.account_id}"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}