locals {
  # Shared
  vpc_cidr               = regex("\\b(?:\\d{1,3}.){1}\\d{1,3}\\b", module.pdc.private_ips[0])
  default_admin_password = nonsensitive(data.aws_secretsmanager_secret_version.radmin_password.secret_string)
  ec2_keypair            = data.aws_secretsmanager_secret_version.ec2_keypair.secret_string

  # PDC
  pdc_name                  = "${var.environment}-PDC"
  pdc_password              = rsadecrypt(module.pdc.password_data[0], local.ec2_keypair)
  pdc_subnet_cidr           = regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", var.private_subnet_cidrs[0])
  all_subnets_3_octet       = concat([for cidr in var.private_subnet_cidrs : regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", cidr)], [for cidr in var.public_subnet_cidrs : regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", cidr)])
  list_reverse_lookup_zones = [for subnet in local.all_subnets_3_octet : "${join(".", reverse(split(".", subnet)))}.in-addr.arpa"]
  reverse_lookup_zones      = join(",", local.list_reverse_lookup_zones)

  # RDC
  rdc_name        = "${var.environment}-RDC"
  rdc_password    = rsadecrypt(module.rdc.password_data[0], local.ec2_keypair)
  rdc_subnet_cidr = regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", var.private_subnet_cidrs[1])

  # Outputs
  domain_list = split(".","${var.domain_name}")
  distinguished_name = join(".", [for dn in local.domain_list : "DC=${dn}"])

}