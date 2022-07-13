locals {
  instance_name       = "${var.environment}-PDC"
  ansible_password    = rsadecrypt(module.pdc.password_data[0], file("~/.ssh/id_rsa"))
  password            = nonsensitive(data.aws_secretsmanager_secret_version.radmin_password.secret_string)
  pdc_subnet_cidr     = regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b", module.pdc.private_ips[0])
  reverse_lookup_zone = join(".", reverse(split(".", local.pdc_subnet_cidr)))
}
module "pdc" {
  source = "../../../base/compute/ec2"

  key_name           = var.key_name
  instance_name      = local.instance_name
  instance_type      = "t3.medium"
  instance_count     = 1
  ami_owner          = "amazon"
  ami_name           = "Windows_Server-2019-English-Full-Base*"
  get_password_data  = true
  operating_system   = "Windows"
  region             = var.region
  subnet_id          = var.private_subnet_id
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
module "secrets" {
  source = "../../../base/secrets-manager"

  names = ["radmin"]
  path  = var.path
}

data "aws_secretsmanager_secret_version" "radmin_password" {
  secret_id = module.secrets.secret_ids[0]
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
      ansible_password = local.ansible_password
      vars = {
        new_hostname        = module.pdc.instance_names[0]
        ansible_user        = "Administrator"
        amazon_dns          = "${regex("\\b(?:\\d{1,3}.){1}\\d{1,3}\\b", module.pdc.private_ips[0])}.0.2"
        pdc_hostname        = module.pdc.private_ips[0]
        domain              = var.domain_name #valhalla.local
        netbios             = var.netbios     #VALHALLA
        password            = local.password
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
