terraform {
  source = "../../../modules//composite/setup"
}
include "root" {
  path = find_in_parent_folders()
}
include "region" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}
inputs = {
  # KMS
  key_name   = "key_to_the_city"
  public_key = file("~/.ssh/id_rsa.pub")

  # VPC
  prefix_name     = include.region.locals.env
  vpc_cidr        = "10.0.0.0/16"
  tgw_cidr        = "10.0.0.0/8"
  region          = include.region.locals.region
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}