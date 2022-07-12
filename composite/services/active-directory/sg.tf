data "aws_vpc" "this" {
  id = var.vpc_id
}
locals {
  ad_tcp = [53, 88, 389, 445, 464, 636, 3268, 3269, 9389]
  ad_udp = [53, 123, 138, 389, 445, 464]
}

resource "aws_security_group" "instance" {
  name   = "active-directory"
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "icmp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = data.aws_vpc.this.cidr_block
}
resource "aws_security_group_rule" "ad_tcp_inbound" {
  for_each          = toset(local.ad_tcp)
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = data.aws_vpc.this.cidr_block
}
resource "aws_security_group_rule" "ad_udp_inbound" {
  for_each          = toset(local.ad_tcp)
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = each.value
  to_port     = each.value
  protocol    = "udp"
  cidr_blocks = data.aws_vpc.this.cidr_block
}
resource "aws_security_group_rule" "ephemeral_tcp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = 49152
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = data.aws_vpc.this.cidr_block
}
resource "aws_security_group_rule" "ephemeral_udp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = 49152
  to_port     = 65535
  protocol    = "udp"
  cidr_blocks = data.aws_vpc.this.cidr_block
}
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
