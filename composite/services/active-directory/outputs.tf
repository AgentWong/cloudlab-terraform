output "domain_name" {
    value = var.domain_name
}
output "distinguished_name" {
    value = local.distinguished_name
}
output "radmin_password_id" {
    value = module.default_admin_password.secret_ids[0]
}