resource "aws_key_pair" "this" {
  key_name   = "key_to_the_city"
  public_key = file("~/.ssh/id_rsa.pub")
}