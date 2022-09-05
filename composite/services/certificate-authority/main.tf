locals {
  # Shared
  radmin_password = nonsensitive(data.aws_secretsmanager_secret_version.radmin_password.secret_string)
  ec2_keypair     = nonsensitive(data.aws_secretsmanager_secret_version.ec2_keypair.secret_string)

  # CA
  ca_password         = rsadecrypt(module.ca.password_data[0], local.ec2_keypair)
  ca_subnet_cidr      = regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", var.private_subnet_cidrs[0])

}
data "aws_secretsmanager_secret_version" "ec2_keypair" {
  secret_id = var.ec2_keypair_secret_id
}
data "aws_secretsmanager_secret_version" "radmin_password" {
  secret_id = var.radmin_password_id
}
module "ca" {
  source = "../../../base/compute/ec2"

  key_name           = var.key_name
  instance_name      = "${var.environment}_CA"
  instance_type      = "t2.small"
  instance_count     = 1
  ami_owner          = "amazon"
  ami_name           = "Windows_Server-2019-English-Full-Base*"
  get_password_data  = true
  operating_system   = "Windows"
  region             = var.region
  subnet_id          = var.private_subnet_ids[0]
  private_ip         = "${local.ca_subnet_cidr}.6"
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.ca.id, var.ansible_winrm_sg_id]
  user_data          = <<EOF
<powershell>
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory "Private"
Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true
winrm quickconfig -quiet
</powershell>
EOF
}
resource "null_resource" "ansible_ca_domain_join" {
  triggers = {
    ansible_bastion_id = module.ca.instance_ids[0]
  }

  connection {
    type             = "ssh"
    user             = "ec2-user"
    private_key      = local.ec2_keypair
    host             = var.ansible_bastion_private_ip
    bastion_user     = "ec2-user"
    bastion_host     = var.linux_bastion_public_dns
    bastion_host_key = local.ec2_keypair
  }

  provisioner "remote-exec" {
    inline = [<<EOF
    ${templatefile("${path.module}/../../../templates/run_playbook.tftpl", {
      ansible_playbook = "windows-join-domain.yml"
      ansible_password = local.ca_password
      vars = {
        new_hostname = module.ca.instance_names[0]
        ansible_user = "Administrator"
        hostname     = module.ca.private_ips[0]
        domain       = var.domain_name
        domain_admin = "radmin@${var.domain_name}"
        password     = local.radmin_password
      }
})}
    EOF
]
}
depends_on = [
  module.ca
]
}
resource "null_resource" "ansible_ca" {
  triggers = {
    ansible_bastion_id = module.ca.instance_ids[0]
  }

  connection {
    type             = "ssh"
    user             = "ec2-user"
    private_key      = local.ec2_keypair
    host             = var.ansible_bastion_private_ip
    bastion_user     = "ec2-user"
    bastion_host     = var.linux_bastion_public_dns
    bastion_host_key = local.ec2_keypair
  }

  provisioner "remote-exec" {
    inline = [<<EOF
    ${templatefile("${path.module}/../../../templates/run_playbook.tftpl", {
      ansible_playbook = "windows-setup-ent-ca.yml"
      ansible_password = local.radmin_password
      vars = {
        ansible_user = "radmin@${var.domain_name}"
        hostname     = "${module.ca.instance_names[0]}.${var.domain_name}"
        domain       = var.domain_name
        domain_dn    = var.distinguished_name
        domain_admin = "radmin@${var.domain_name}"
        password     = local.radmin_password
      }
})}
    EOF
]
}
depends_on = [
  null_resource.ansible_ca_domain_join
]
}
