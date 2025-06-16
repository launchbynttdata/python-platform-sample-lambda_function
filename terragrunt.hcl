
locals {
  naming_prefix = "sample_lambda"

  # Loads the account related details like account name, id etc.
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Loads the aws region information
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_name = local.account_vars.locals.account_name
  region       = local.region_vars.locals.region

  relative_path      = path_relative_to_include()
  environment_instance = basename(local.relative_path)
  bucket          = "${replace(local.naming_prefix, "_", "-")}-${local.region}-${local.account_name}-${local.environment_instance}-tfstate"
  dynamodb_table  = "${local.naming_prefix}-${local.region}-${local.account_name}-${local.environment_instance}-tflocks"
}

# Generate the AWS provider settings
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "${local.region}"

  default_tags {
    tags = {
      Organization = var.organization_tag
      Repository = var.repository_tag
      CommitHash = var.commit_hash_tag
    }
  }
}

provider "aws" {
  alias   = "global"
  region  = "us-east-1"

  default_tags {
    tags = {
      Organization = var.organization_tag
      Repository = var.repository_tag
      CommitHash = var.commit_hash_tag
    }
  }
}

variable "organization_tag" {
  type = string
}

variable "repository_tag" {
  type = string
}

variable "commit_hash_tag" {
  type = string
}

EOF
}

# Generates the config file for s3 backend
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "${local.bucket}"
    key            = "terraform.tfstate"
    region         = "${local.region}"
    encrypt        = true
    dynamodb_table = "${local.dynamodb_table}"
  }
}

inputs = {
  naming_prefix = local.naming_prefix
  environment   = local.account_name
  region        = local.region
}