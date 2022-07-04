module "alb" {
  source = "../../../base/network/alb"

  alb_name          = var.service_name
  subnet_ids        = var.subnet_ids
  vpc_id            = var.vpc_id
  alb_ingress_ports = var.alb_ingress_ports
}
module "asg" {
  source = "../../../base/compute/asg"

  cluster_name       = var.service_name
  ami_name           = var.ami_name
  ami_owner          = var.ami_owner
  user_data          = var.user_data
  key_name           = var.key_name
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  enable_autoscaling = false
  subnet_ids         = var.subnet_ids
  target_group_arns  = [module.alb.target_group_arn]
  health_check_type  = var.health_check_type
  ingress_ports      = var.ingress_ports
  vpc_id             = var.vpc_id
}
