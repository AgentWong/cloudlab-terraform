# EC2
variable "user_data" {}
variable "instance_name" {}
variable "ami_owner" {}
variable "ami_name" {}
variable "key_name" {}
variable "instance_count" {}
variable "instance_type" {}

# ALB
variable "alb_name" {}
variable "vpc_id" {}
variable "subnet1_id" {}
variable "subnet2_id" {}