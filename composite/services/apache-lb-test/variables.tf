# Shared
variable "vpc_id" {
  description = "The VPC ID to deploy to"
  type        = string
}
variable "service_name" {
  description = "The name to use for this service module resources"
  type        = string
}
variable "subnet_ids" {
  description = "A list of subnet ids"
  type        = list(string)
}

# ALB
variable "alb_ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}
variable "instance_ids" {
  description = "The instance ids for the target group"
  type        = list(string)
}

# EC2
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}
variable "ami_owner" {
  description = "The owner ID or alias for the account that owns the AMI"
  type        = string
}
variable "ami_name" {
  description = "The AMI image name, include any wildcards"
  type        = string
}
variable "key_name" {
  description = "The EC2 keypair to use"
  type        = string
}
variable "instance_count" {
  description = "The number of instances to deploy"
  type        = number
}
variable "ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}
variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
}
