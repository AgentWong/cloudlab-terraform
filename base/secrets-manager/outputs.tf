output "secret_ids" {
  value = values(aws_secretsmanager_secret_version.this)[*].secret_id
}