data "aws_ami" "instance" {
  most_recent = true
  owners      = ["${var.ami_owner}"]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}
