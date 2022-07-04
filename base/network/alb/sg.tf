resource "aws_security_group" "alb" {
  name   = "${var.alb_name}-alb"
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "allow_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = var.alb_ingress_port
  to_port     = var.alb_ingress_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
