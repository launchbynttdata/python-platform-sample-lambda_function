create_package = true
create         = true
handler        = "app.lambda_handler"
cors           = { allow_origins = ["*"] }
source_path    = "../../../../../../../src/function/"
name           = "platform_sample-useast2-sandbox-000-fn-000"
environment_variables = {
  PAYLOAD = "Primary-East"
}
