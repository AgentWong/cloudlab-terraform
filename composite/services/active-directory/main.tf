locals {
  instance_name = "${var.environment}-DC-01"
}
module "pdc" {
  source = "../../../base/compute/ec2"

  key_name                    = var.key_name
  instance_name               = local.instance_name
  instance_type               = "t3.medium"
  instance_count              = 1
  ami_owner                   = "amazon"
  ami_name                    = "Windows_Server-2019-English-Full-Base*"
  operating_system            = "Windows"
  region                      = var.region
  subnet_id                   = var.private_subnet_id
  vpc_id                      = var.vpc_id
  security_group_ids          = [aws_security_group.instance.id, var.ansible_winrm_sg_id]
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
    inline = <<EOF
    ${templatefile("${path.module}/../../../templates/run_playbook.tftpl",{
      ansible_playbook = "windows-setup-pdc.yml"
      ansible_password = rsadecrypt(module.pdc.password_data[0],file("~/.ssh/id_rsa"))
      vars = {
        amazon_dns = "${regex("\\b(?:\\d{1,3}.){1}\\d{1,3}\\b",module.pdc.private_ips[0])}.0.2"
        pdc_hostname = module.pdc.private_ips[0]
        domain = var.domain_name #valhalla.local
        netbios = var.netbios #VALHALLA
        password = data.aws_secretsmanager_secret_version.radmin_password.secret_string
        reverse_lookup_zone = "${strrev(regex("\\b(?:\\d{1,3}.){2}\\d{1,3}\\b",module.pdc.private_ips[0]))}.in-addr.arpa"
      }
    })}
    EOF
  }
  depends_on = [
    module.pdc
  ]
}