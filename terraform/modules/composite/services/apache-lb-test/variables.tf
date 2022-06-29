# EC2
variable "count" {}
variable "user_data" {}
variable "instance_name" {}
variable "ami_owner" {}
variable "ami_name" {}
variable "subnet_id" {}

# ALB
variable "alb_name" {}
variable "public_subnets" {}
variable "vpc_id" {}