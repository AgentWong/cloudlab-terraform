resource "aws_secretsmanager_secret" "this" {
  for_each = { for k, v in var.names : v => v }
  name     = "${var.path}/${each.value}"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "this" {
  for_each      = { for k, v in var.names : v => v }
  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = random_password.this[each.key].result
}
resource "random_password" "this" {
  for_each         = { for k, v in var.names : v => v }
  length           = var.length
  special          = var.special
  override_special = var.override_special
  min_lower        = var.min_lower
  min_upper        = var.min_upper
  min_numeric      = var.min_numeric
  min_special      = var.min_special
}
