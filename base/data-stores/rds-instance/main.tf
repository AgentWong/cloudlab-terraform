resource "aws_db_instance" "this" {
  identifier_prefix      = var.identifier_prefix
  engine                 = var.engine
  allocated_storage      = var.storage
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible = false
}
resource "aws_db_subnet_group" "this" {
  name       = "main"
  subnet_ids = [var.private_subnet_id]
}