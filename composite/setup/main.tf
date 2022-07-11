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
  source = "../../../base/compute/ec2"

  key_name          = module.kms.key_name
  instance_name     = "ansible-bastion"
  instance_type     = var.instance_type
  instance_count    = 1
  ami_owner         = var.ami_owner
  ami_name          = var.ami_name
  operating_system  = "Linux"
  subnet_id         = module.vpc.public_subnets[0]
  vpc_id            = module.vpc.vpc_id
  security_group_id = aws_security_group.instance.id
  user_data         = <<EOF
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
