locals {
  # Shared
  vpc_cidr               = regex("\\b(?:\\d{1,3}.){1}\\d{1,3}\\b", module.pdc.private_ips[0])
  default_admin_password = nonsensitive(data.aws_secretsmanager_secret_version.radmin_password.secret_string)

  # PDC
  pdc_name            = "${var.environment}-PDC"
  pdc_password        = rsadecrypt(module.pdc.password_data[0], file("~/.ssh/id_rsa"))
  pdc_subnet_cidr     = regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", var.pdc_subnet_cidr)
  reverse_lookup_zone = join(".", reverse(split(".", local.pdc_subnet_cidr)))

  # RDC
  rdc_name        = "${var.environment}-RDC"
  rdc_password    = rsadecrypt(module.rdc.password_data[0], file("~/.ssh/id_rsa"))
  rdc_subnet_cidr = regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", var.rdc_subnet_cidr)

}
module "default_admin_password" {
  source = "../../../base/secrets-manager"

  names = ["radmin"]
  path  = var.path
}
data "aws_secretsmanager_secret_version" "radmin_password" {
  secret_id = module.default_admin_password.secret_ids[0]
}
module "pdc" {
  source = "../../../base/compute/ec2"

  key_name           = var.key_name
  instance_name      = local.pdc_name
  instance_type      = "t3.medium"
  instance_count     = 1
  ami_owner          = "amazon"
  ami_name           = "Windows_Server-2019-English-Full-Base*"
  get_password_data  = true
  operating_system   = "Windows"
  region             = var.region
  subnet_id          = var.pdc_subnet_id
  private_ip         = "${local.pdc_subnet_cidr}.5"
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.instance.id, var.ansible_winrm_sg_id]
  user_data          = <<EOF
<powershell>
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory "Private"
Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true
winrm quickconfig -quiet
</powershell>
EOF
}
resource "null_resource" "ansible_pdc" {
  triggers = {
    ansible_bastion_id = module.pdc.instance_ids[0]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = var.ansible_bastion_public_dns
  }

  provisioner "remote-exec" {
    inline = [<<EOF
    ${templatefile("${path.module}/../../../templates/run_playbook.tftpl", {
      ansible_playbook = "windows-setup-pdc.yml"
      ansible_password = local.pdc_password
      vars = {
        new_hostname        = module.pdc.instance_names[0]
        ansible_user        = "Administrator"
        dns_server          = "${local.vpc_cidr}.0.2" # Amazon DNS
        pdc_hostname        = "${local.pdc_subnet_cidr}.5"
        domain              = var.domain_name
        netbios             = var.netbios
        password            = local.default_admin_password
        reverse_lookup_zone = "${local.reverse_lookup_zone}.in-addr.arpa"
      }
})}
    EOF
]
}
depends_on = [
  module.pdc
]
}
module "rdc" {
  source = "../../../base/compute/ec2"

  key_name           = var.key_name
  instance_name      = local.rdc_name
  instance_type      = "t3.medium"
  instance_count     = 1
  ami_owner          = "amazon"
  ami_name           = "Windows_Server-2019-English-Full-Base*"
  get_password_data  = true
  operating_system   = "Windows"
  region             = var.region
  subnet_id          = var.rdc_subnet_id
  private_ip         = "${local.rdc_subnet_cidr}.5"
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.instance.id, var.ansible_winrm_sg_id]
  user_data          = <<EOF
<powershell>
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory "Private"
Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true
winrm quickconfig -quiet
</powershell>
EOF
  depends_on = [
    null_resource.ansible_pdc
  ]
}
resource "null_resource" "ansible_rdc_domain_join" {
  triggers = {
    ansible_bastion_id = module.rdc.instance_ids[0]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = var.ansible_bastion_public_dns
  }

  provisioner "remote-exec" {
    inline = [<<EOF
    ${templatefile("${path.module}/../../../templates/run_playbook.tftpl", {
      ansible_playbook = "windows-join-domain.yml"
      ansible_password = local.rdc_password
      vars = {
        new_hostname = module.rdc.instance_names[0]
        ansible_user = "Administrator"
        dns_server   = "${local.pdc_subnet_cidr}.5" # PDC
        hostname     = "${local.rdc_subnet_cidr}.5"
        domain       = var.domain_name
        domain_admin = "radmin@${var.domain_name}"
        password     = local.default_admin_password
      }
})}
    EOF
]
}
depends_on = [
  module.rdc
]
}
resource "null_resource" "ansible_rdc" {
  triggers = {
    ansible_bastion_id = module.rdc.instance_ids[0]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = var.ansible_bastion_public_dns
  }

  provisioner "remote-exec" {
    inline = [<<EOF
    ${templatefile("${path.module}/../../../templates/run_playbook.tftpl", {
      ansible_playbook = "windows-setup-rdc.yml"
      ansible_password = local.default_admin_password
      vars = {
        ansible_user = "radmin@${var.domain_name}"
        rdc_hostname = "${local.rdc_subnet_cidr}.5"
        domain       = var.domain_name
        domain_admin = "radmin@${var.domain_name}"
        password     = local.default_admin_password
      }
})}
    EOF
]
}
depends_on = [
  null_resource.ansible_rdc_domain_join
]
}

/* resource "aws_vpc_dhcp_options" "this" {
  domain_name          = var.domain_name
  domain_name_servers  = ["${local.pdc_subnet_cidr}.5", "${local.rdc_subnet_cidr}.5", "${local.vpc_cidr}.0.2"]
  ntp_servers          = ["${local.pdc_subnet_cidr}.5", "${local.rdc_subnet_cidr}.5", "169.254.169.123"]
  netbios_name_servers = ["${local.pdc_subnet_cidr}.5", "${local.rdc_subnet_cidr}.5"]
  netbios_node_type    = 2
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
} */
