data "aws_secretsmanager_secret_version" "ec2_keypair" {
  secret_id = var.ec2_keypair_secret_id
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
  instance_type      = "t2.small"
  instance_count     = 1
  ami_owner          = "amazon"
  ami_name           = "Windows_Server-2019-English-Full-Base*"
  get_password_data  = true
  operating_system   = "Windows"
  region             = var.region
  subnet_id          = var.private_subnet_ids[0]
  private_ip         = "${local.pdc_subnet_cidr}.5"
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.ad.id, var.ansible_winrm_sg_id]
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
      ansible_playbook = "windows-setup-pdc.yml"
      ansible_password = local.pdc_password
      vars = {
        new_hostname         = module.pdc.instance_names[0]
        ansible_user         = "Administrator"
        dns_server           = "${var.vpc_cidr}.0.2" # Amazon DNS
        pdc_hostname         = "${local.pdc_subnet_cidr}.5"
        domain               = var.domain_name
        netbios              = var.netbios
        password             = local.default_admin_password
        reverse_lookup_zones = "${local.reverse_lookup_zones}"
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
  instance_type      = "t2.small"
  instance_count     = 1
  ami_owner          = "amazon"
  ami_name           = "Windows_Server-2019-English-Full-Base*"
  get_password_data  = true
  operating_system   = "Windows"
  region             = var.region
  subnet_id          = var.private_subnet_ids[1]
  private_ip         = "${local.rdc_subnet_cidr}.5"
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.ad.id, var.ansible_winrm_sg_id]
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
      ansible_playbook = "windows-setup-rdc.yml"
      ansible_password = local.rdc_password
      vars = {
        ansible_user = "Administrator"
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
resource "null_resource" "reboot_rdc" {
  triggers = {
    ansible_bastion_id = module.rdc.instance_ids[0]
  }

  provisioner "local-exec" {
    command = <<EOT
    aws ec2 reboot-instances --instance-ids ${module.rdc.instance_ids[0]} --region ${var.region}
    sleep 180s
    EOT
  }
  depends_on = [
    null_resource.ansible_rdc
  ]
}
resource "null_resource" "ansible_rdc_finish" {
  triggers = {
    ansible_bastion_id = module.rdc.instance_ids[0]
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
      ansible_playbook = "windows-finish-rdc-setup.yml"
      ansible_password = local.default_admin_password
      vars = {
        ansible_user = "radmin@${var.domain_name}"
        pdc_hostname = "${local.pdc_subnet_cidr}.5"
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
  null_resource.reboot_rdc
]
}


resource "aws_vpc_dhcp_options" "this" {
  domain_name          = var.domain_name
  domain_name_servers  = ["${local.pdc_subnet_cidr}.5", "${local.rdc_subnet_cidr}.5", "${var.vpc_cidr}.0.2"]
  ntp_servers          = ["${local.pdc_subnet_cidr}.5", "${local.rdc_subnet_cidr}.5", "169.254.169.123"]
  netbios_name_servers = ["${local.pdc_subnet_cidr}.5", "${local.rdc_subnet_cidr}.5"]
  netbios_node_type    = 2
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
  depends_on = [
    null_resource.ansible_rdc_finish
  ]
}