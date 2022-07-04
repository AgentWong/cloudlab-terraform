locals {
  db_port = tostring(module.rds-mysql.port)
}
module "alb" {
  source = "../../../base/network/alb"

  alb_name         = var.service_name
  subnet_ids       = var.subnet_ids
  vpc_id           = var.vpc_id
  alb_ingress_port = 80
}
module "asg" {
  source = "../../../base/compute/asg"

  cluster_name = var.service_name
  ami_name     = var.ami_name
  ami_owner    = var.ami_owner
  user_data = templatefile("${path.module}/user-data.sh", {
    server_text = "This is a lamp test!"
    db_endpoint = "${module.rds-mysql.address}"
    db_password = "${data.aws_secretsmanager_secret_version.mysql_password.secret_string}"
  })
  key_name           = var.key_name
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  enable_autoscaling = false
  subnet_ids         = var.subnet_ids
  target_group_arns  = [module.alb.target_group_arn]
  health_check_type  = var.health_check_type
  vpc_id             = var.vpc_id
  ingress_ports      = [80]
  security_group_id  = aws_security_group.instance.id
}
module "rds-mysql" {
  source = "../../../base/data-stores/rds-instance"

  identifier_prefix = var.service_name
  db_name           = "lamptest"
  db_username       = "admin"
  db_password       = data.aws_secretsmanager_secret_version.mysql_password.secret_string
  engine            = "mysql"
  storage           = 10
  instance_class    = "db.t2.micro"
  security_group_id = aws_security_group.instance.id
  vpc_id            = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
}
module "secrets" {
  source = "../../../base/secrets-manager"

  names = ["mysql_password"]
  path  = var.path
}

data "aws_secretsmanager_secret_version" "mysql_password" {
  secret_id = module.secrets.secret_ids[0]
}
