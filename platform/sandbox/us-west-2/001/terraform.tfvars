create_package = true
create         = true
handler        = "app.alternate_lambda_handler"
cors           = { allow_origins = ["*"] }
source_path    = "../../../../../../../src/function/"
name           = "platform-sample-lambda-function-2"
environment_variables = {
  PAYLOAD = "Failover-West"
}
