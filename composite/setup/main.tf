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
  instance_type               = "t3.micro"
  instance_count              = 1
  associate_public_ip_address = true
  ami_owner                   = "amazon"
  ami_name                    = "amzn2-ami-hvm*x86_64*gp2"
  operating_system            = "Linux"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_id                      = module.vpc.vpc_id
  security_group_ids          = [aws_security_group.instance.id]
  user_data                   = <<EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable ansible2
    yum install -y ansible git
    git clone https://github.com/AgentWong/cloudlab-ansible.git /home/ec2-user/ansible
    chown -R ec2-user:ec2-user /home/ec2-user/ansible
    EOF
}
resource "aws_eip" "ansible-bastion" {
  vpc                       = true
  network_interface         = module.ansible-bastion.primary_network_interface_ids[0]
  associate_with_private_ip = module.ansible-bastion.private_ips[0]
}
