variable "user_data" {}
variable "instance_name" {}
variable "ami_owner" {}
variable "ami_name" {}
variable "subnet_id" {}
variable "key_name" {}
variable "instance_count" {}
variable "vpc_id" {}
variable "instance_type" {
    default = "t2.micro"
}