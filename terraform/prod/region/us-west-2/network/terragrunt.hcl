terraform {
  source = "../../../../modules//base/network"
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "us-west-2"
  }
  EOF
}
include "root" {
  path = find_in_parent_folders()
}
inputs = {
  vpc_name        = "vpc-prod"
  vpc_cidr        = "10.0.0.0/16"
  region          = "us-west-2"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
