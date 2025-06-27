include "root" {
  path = find_in_parent_folders()
}

include "state" {
  path = find_in_parent_folders("state-persistent.hcl")
}

locals {
  git_tag = "1.0.0"
}

terraform {
  source = "tfr://terraform.registry.launch.nttdata.com/module_reference/lambda_function/aws?version=${local.git_tag}"
}
