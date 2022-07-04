module "asg" {
  source = "../../../base/compute/asg"

  cluster_name = var.service_name
  ami_name     = var.ami_name
  ami_owner    = var.ami_owner
  user_data = templatefile("${path.module}/user-data.sh", {
    server_text = "Hello World!"
    db_address  = module.rds-mysql.address
    db_port     = module.rds-mysql.port
    server_port = var.alb_ingress_ports
  })
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
module "alb" {
  source = "../../../base/network/alb"

  alb_name          = var.service_name
  subnet_ids        = var.subnet_ids
  vpc_id            = var.vpc_id
  alb_ingress_ports = var.alb_ingress_ports
}
module "secrets" {
  source = "../../../base/secrets-manager"

  names = ["mysql_password"]
  path = var.path
}
module "rds-mysql" {
  source = "../../../base/data-stores/rds-instance"

  db_name        = var.service_name
  db_username    = "admin"
  db_password    = jsondecode(data.aws_secretsmanager_secret_version.mysql_password)["mysql_password"]
  engine         = "mysql"
  storage        = 10
  instance_class = "db.t2.micro"
}

data "aws_secretsmanager_secret_version" "mysql_password" {
  secret_id = module.secrets.secret_ids[0]
}
