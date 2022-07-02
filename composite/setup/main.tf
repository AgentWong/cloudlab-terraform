module "kms" {
  source = "../../base/compute/ec2-keypair"

  key_name   = var.key_name
  public_key = var.public_key
}
module "vpc" {
  source = "../../base/network/vpc"

  prefix_name     = var.prefix_name
  vpc_cidr        = var.vpc_cidr
  tgw_cidr        = var.tgw_cidr
  region          = var.region
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
