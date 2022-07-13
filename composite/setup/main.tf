module "kms" {
  source = "../../base/compute/ec2-keypair"

  key_name   = var.key_name
  public_key = var.public_key
}
module "vpc" {
  source = "../../base/network/vpc"

  prefix_name     = var.prefix_name
  vpc_cidr        = var.vpc_cidr
  tgw_cidr        = var.tgw_cidr
  region          = var.region
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
module "ansible-bastion" {
  source = "../../base/compute/ec2"

  key_name                    = module.kms.key_name
  instance_name               = "ansible-bastion"
  instance_type               = "t2.micro"
  instance_count              = 1
  iam_instance_profile        = aws_iam_instance_profile.ansible_inventory_profile.name
  associate_public_ip_address = true
  ami_owner                   = "309956199498"
  ami_name                    = "RHEL-8*HVM*x86_64*GP2*"
  operating_system            = "Linux"
  region                      = var.region
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_id                      = module.vpc.vpc_id
  security_group_ids          = [aws_security_group.instance.id]
  user_data                   = <<EOF
    #!/bin/bash
    yum update -y
    yum install -y ansible git python3-pip python3-setuptools python3-boto3 gcc python3-devel krb5-devel krb5-libs krb5-workstation
    pip3 install wheel
    pip3 install pywinrm[kerberos]
    git clone https://github.com/AgentWong/cloudlab-ansible.git /home/ec2-user/ansible
    chown -R ec2-user:ec2-user /home/ec2-user/ansible
    EOF
}
resource "aws_eip" "ansible-bastion" {
  vpc                       = true
  network_interface         = module.ansible-bastion.primary_network_interface_ids[0]
  associate_with_private_ip = module.ansible-bastion.private_ips[0]
}

resource "null_resource" "copy_private_key" {
  triggers = {
    ansible_bastion_id = module.ansible-bastion.instance_ids[0]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_eip.ansible-bastion.public_dns
  }

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "/home/ec2-user/.ssh/id_rsa"
  }
  depends_on = [
    module.ansible-bastion
  ]
}
