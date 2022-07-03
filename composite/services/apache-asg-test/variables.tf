# Shared
variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# ASG
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
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
variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
}
variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
}

# ALB
variable "alb_name" {
  description = "The name of the application load balancer"
  type        = string
}
variable "alb_ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}
variable "instance_ids" {
  description = "The instance ids for the target group"
  type        = list(string)
}
