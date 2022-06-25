remote_state {
  backend = "s3"
  config = {
    bucket = "eden-prod-4ecd0688"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = "eden-locks"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
        backend "s3" {}
    }
  EOF
}