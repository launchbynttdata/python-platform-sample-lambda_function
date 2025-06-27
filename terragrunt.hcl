
locals {
  # After initial apply, changes to these naming values will result in the creation of new state bucket(s) and dynamodb table(s)!
  logical_product_family = "sample"
  logical_product_service = "lambda"

  # Don't modify the locals below this line.
  name_dash                = replace("${trimspace(local.logical_product_family)}_${trimspace(local.logical_product_service)}", "_", "-")
  name_hash                = substr(sha256(local.name_dash), 0, 8)
  resource_names_strategy  = local.account_name == "sandbox" ? "minimal_random_suffix" : "standard"
  relative_path            = path_relative_to_include()
  path_parts               = split("/", local.relative_path)
  account_name             = local.path_parts[1]
  region                   = local.path_parts[2]
  environment_instance     = basename(local.relative_path)
  git_branch               = get_env("GIT_BRANCH", "")
  current_user             = get_env("USER", "")
  bucket                   = "${local.name_dash}-${local.region}-${local.name_hash}-tfstate"
  dynamodb_table           = "${local.name_dash}-${local.region}-${local.name_hash}-tflocks"
  repo_name                = basename(abspath("${get_path_to_repo_root()}"))
  state_filename_ephemeral = "${local.account_name}/${coalesce(local.git_branch, local.current_user)}/${local.environment_instance}/terraform.tfstate"
  state_filename_persist   = "${local.account_name}/${local.environment_instance}/terraform.tfstate"
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
      Repository = coalesce(var.repository_tag, "${basename(abspath(dirname(find_in_parent_folders("terragrunt.hcl"))))}")
      Branch = var.branch_tag
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
      Repository = coalesce(var.repository_tag, "${basename(abspath(dirname(find_in_parent_folders("terragrunt.hcl"))))}")
      Branch = var.branch_tag
      CommitHash = var.commit_hash_tag
    }
  }
}

variable "organization_tag" {
  type = string
  default = "launchbynttdata"
}

variable "repository_tag" {
  type = string
  default = ""
}

variable "branch_tag" {
  type = string
  default = "RUN OUTSIDE PIPELINE"
}

variable "commit_hash_tag" {
  type = string
  default = "RUN OUTSIDE PIPELINE"
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
    key            = local.account_name == "sandbox" ? local.state_filename_ephemeral : local.state_filename_persist
    region         = "${local.region}"
    encrypt        = true
    dynamodb_table = "${local.dynamodb_table}"
  }
}

inputs = {
  logical_product_family  = local.logical_product_family
  logical_product_service = local.logical_product_service
  class_env               = local.account_name
  region                  = local.region
  resource_names_strategy = local.resource_names_strategy
}
