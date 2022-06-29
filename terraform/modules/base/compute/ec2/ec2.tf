resource "aws_instance" "prod_instance" {
  count                  = var.count
  ami                    = data.aws_ami.instance.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = var.subnet_id
  user_data              = var.user_data
  tags = {
    Name = "${var.instance_name}"
  }
}
