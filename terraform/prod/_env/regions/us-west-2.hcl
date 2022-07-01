generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "us-west-2"
  }
  EOF
}
locals {
  region = "us-west-2"
}