create_package = true
create         = true
handler        = "app.lambda_handler"
cors           = { allow_origins = ["*"] }
source_path    = "../../../../../../../src/function/"
name           = "platform_sample-useast1-production-000-fn-000"
environment_variables = {
  PAYLOAD = "Primary"
}

