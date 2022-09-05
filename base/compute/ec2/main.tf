locals {
  instance_name = toset([for i in range(1, var.instance_count + 1) : format("%s_%02d", var.instance_name, i)])
}
resource "aws_instance" "this" {
  for_each                    = local.instance_name
  ami                         = data.aws_ami.instance.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  get_password_data           = var.get_password_data
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = var.user_data
  private_ip                  = var.private_ip
  associate_public_ip_address = var.associate_public_ip_address
  tags = {
    Name = "${each.value}"
    OS   = "${var.operating_system}"
  }
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${self.id} --region ${var.region}"
  }
}
