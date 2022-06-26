terraform {
  source = "../../../../modules//base/network"
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "us-east-1"
  }
  EOF
}
include "root" {
  path = find_in_parent_folders()
}
inputs = {
  prefix_name     = "dr"
  vpc_cidr        = "172.16.0.0/16"
  tgw_cidr        = "172.0.0.0/8"
  region          = "us-east-1"
  public_subnets  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}
