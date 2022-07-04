resource "aws_db_instance" "this" {
  engine              = var.engine
  allocated_storage   = var.storage
  instance_class      = var.instance_class
  name                = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}
