include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-lambda_function//.?ref=1.0.3"
}