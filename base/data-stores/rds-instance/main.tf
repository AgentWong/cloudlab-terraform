resource "aws_db_instance" "this" {
  identifier_prefix   = var.identifier_prefix
  engine              = var.engine
  allocated_storage   = var.storage
  instance_class      = var.instance_class
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}
