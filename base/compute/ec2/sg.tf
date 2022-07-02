resource "aws_security_group" "instance" {
  name   = var.instance_name
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "allow_inbound" {
  for_each          = { for k, v in var.ingress_ports : v => v }
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
