terraform {
  source = "../../../../modules//composite/setup"
}
include "root" {
  path = find_in_parent_folders()
}
include "region" {
  path = "${dirname(find_in_parent_folders())}/region/us-west-2/region.hcl"
}
inputs = {
  # KMS
  key_name   = "key_to_the_city"
  public_key = file("~/.ssh/id_rsa.pub")

  # VPC
  prefix_name     = "dr"
  vpc_cidr        = "172.16.0.0/16"
  tgw_cidr        = "172.0.0.0/8"
  region          = "us-west-2"
  public_subnets  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}