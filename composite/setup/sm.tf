resource "aws_secretsmanager_secret" "ec2_private_key" {
  name = var.key_name
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "ec2_private_key" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key.id
  secret_string = file("~/.ssh/id_rsa")
}