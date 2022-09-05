data "aws_vpc" "this" {
  id = var.vpc_id
}
locals {
  ca_tcp = [135, 3389]
}

resource "aws_security_group" "ca" {
  name   = "certificate-authority"
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "icmp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.ca.id

  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = [data.aws_vpc.this.cidr_block]
}
resource "aws_security_group_rule" "ca_tcp_inbound" {
  for_each          = { for k,v in local.ca_tcp : v => v}
  type              = "ingress"
  security_group_id = aws_security_group.ca.id

  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.this.cidr_block]
}
resource "aws_security_group_rule" "ephemeral_tcp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.ca.id

  from_port   = 49152
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.this.cidr_block]
}
resource "aws_security_group_rule" "ephemeral_udp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.ca.id

  from_port   = 49152
  to_port     = 65535
  protocol    = "udp"
  cidr_blocks = [data.aws_vpc.this.cidr_block]
}
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.ca.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
