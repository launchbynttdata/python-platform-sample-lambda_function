include "root" {
  path = find_in_parent_folders()
}

locals {
  git_tag = "1.0.3"
}

terraform {
  source = "tfr://terraform.registry.launch.nttdata.com/module_primitive/lambda_function/aws?version=${local.git_tag}"
}
