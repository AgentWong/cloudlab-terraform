# Ansible Bastion
resource "aws_security_group" "ansible_bastion" {
  name   = "${var.prefix_name}-ansible-bastion"
  vpc_id = module.vpc.vpc_id
}
resource "aws_security_group_rule" "ansible_bastion_icmp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.ansible_bastion.id

  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = var.linux_mgmt_cidr
}
resource "aws_security_group_rule" "ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.ansible_bastion.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.linux_mgmt_cidr
}
resource "aws_security_group_rule" "linux_bastion_allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.linux_bastion.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "linux_mgmt" {
  name   = "${var.prefix_name}-linux-mgmt"
  vpc_id = module.vpc.vpc_id
}
resource "aws_security_group_rule" "ssh_mgmt_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.linux_mgmt.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  source_security_group_id = aws_security_group.ansible_bastion.id
}
resource "aws_security_group" "winrm_mgmt" {
  name   = "${var.prefix_name}-winrm-mgmt"
  vpc_id = module.vpc.vpc_id
}
resource "aws_security_group_rule" "winrm_mgmt_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.winrm_mgmt.id

  from_port   = 5985
  to_port     = 5986
  protocol    = "tcp"
  source_security_group_id = aws_security_group.ansible_bastion.id
}

# windows Bastion
resource "aws_security_group" "windows_bastion" {
  name   = "${var.prefix_name}-windows-bastion"
  vpc_id = module.vpc.vpc_id
}
resource "aws_security_group_rule" "windows_bastion_icmp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.windows_bastion.id

  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = var.linux_mgmt_cidr
}
resource "aws_security_group_rule" "rdp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.windows_bastion.id

  from_port   = 3389
  to_port     = 3389
  protocol    = "tcp"
  cidr_blocks = var.linux_mgmt_cidr
}
resource "aws_security_group_rule" "windows_bastion_allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.windows_bastion.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}