# ASG
variable "cluster_name" {}
variable "min_size" {}
variable "max_size" {}
variable "ami_name" {}
variable "ami_owner" {}
variable "key_name" {}
variable "instance_type" {}
variable "ingress_ports" {
    type = list(number)
}
variable "health_check_type" {}
variable "user_data" {}

# ALB
variable "alb_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
    type = list(string)
}