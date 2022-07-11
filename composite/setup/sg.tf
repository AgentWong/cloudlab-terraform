resource "aws_security_group" "instance" {
  name   = var.service_name
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.linux_mgmt_cidr
}
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "linux_mgmt" {
  name   = var.service_name
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.linux_mgmt.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  source_security_group_id = aws_security_group.instance.id
}

resource "aws_security_group" "winrm_mgmt" {
  name   = var.service_name
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "winrm_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.winrm_mgmt.id

  from_port   = 5985
  to_port     = 5985
  protocol    = "tcp"
  source_security_group_id = aws_security_group.instance.id
}