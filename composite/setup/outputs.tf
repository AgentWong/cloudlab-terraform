# KMS
output "key_name" {
    value = module.kms.key_name
}
output "ec2_keypair_secret_id" {
  value = aws_secretsmanager_secret.ec2_private_key.id
}

# VPC
output "public_subnet_cidr_blocks" {
    value = module.vpc.public_subnet_cidr_blocks
}
output "private_subnet_cidr_blocks" {
    value = module.vpc.private_subnet_cidr_blocks
}
output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
}
output "vpc_id" {
    value = module.vpc.vpc_id
}

# Ansible Management
output "linux_mgmt_sg_id" {
    value = aws_security_group.linux_mgmt.id
}
output "winrm_mgmt_sg_id" {
    value = aws_security_group.winrm_mgmt.id
}
output "linux_bastion_public_dns" {
    value = aws_eip.linux-bastion.public_dns
}
output "ansible_bastion_private_dns" {
    value = aws_eip.linux-bastion.private_dns
}