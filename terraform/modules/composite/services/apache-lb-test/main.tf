module "ec2" {
  source = "../../../base/compute/ec2"

  user_data      = var.user_data
  key_name       = var.key_name
  instance_name  = var.instance_name
  instance_type  = var.instance_type
  instance_count = var.instance_count
  ami_owner      = var.ami_owner
  ami_name       = var.ami_name
  subnet_id      = var.subnet1_id
  vpc_id         = var.vpc_id
}
module "alb" {
  source = "../../../base/network/alb"

  alb_name     = var.alb_name
  subnet1_id   = var.subnet1_id
  subnet2_id   = var.subnet2_id
  vpc_id       = var.vpc_id
  instance_ids = module.ec2.instance_ids
}
