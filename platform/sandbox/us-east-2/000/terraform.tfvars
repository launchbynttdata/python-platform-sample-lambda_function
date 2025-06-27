create_package          = true
create                  = true
handler                 = "app.lambda_handler"
cors                    = { allow_origins = ["*"] }
source_path             = "../../../../../../../src/function/"
environment_variables   = {
  PAYLOAD = "Primary-East"
}
