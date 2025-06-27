create_package          = true
create                  = true
handler                 = "app.lambda_handler"
cors                    = { allow_origins = ["*"] }
source_path             = "../../../../../../../src/function/"
resource_names_strategy = "minimal_random_suffix"
environment_variables   = {
  PAYLOAD = "Primary-West"
}
