# Shared
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "subnet_ids" {
  description = "A list of subnet ids"
  type        = list(string)
}
variable "service_name" {
  description = "The name to use for this service module resources"
  type        = string
}

# ASG
variable "ami_owner" {
  description = "The owner ID or alias for the account that owns the AMI"
  type        = string
}
variable "ami_name" {
  description = "The AMI image name, include any wildcards"
  type        = string
}
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}
variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}
variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}
variable "key_name" {
  description = "The EC2 keypair to use"
  type        = string
}
variable "ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}
variable "target_group_arns" {
  description = "The ARNs of load balancer target groups in which to register Instances"
  type        = list(string)
}
variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
}

# ALB
variable "alb_ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}

# SM
variable "path" {
  description = "The path to organize secrets"
  type        = string
}
