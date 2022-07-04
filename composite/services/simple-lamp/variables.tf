# Shared
variable "service_name" {
  description = "The name to use for this service module resources"
  type        = string
}
variable "subnet_ids" {
  description = "A list of subnet ids"
  type        = list(string)
}
variable "vpc_id" {
  description = "VPC ID"
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
variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
}
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}
variable "key_name" {
  description = "The EC2 keypair to use"
  type        = string
}
variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}
variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}
variable "linux_mgmt_cidr" {
  description = "CIDR block to allow SSH access."
  type        = list(string)
}

# RDS
variable "private_subnet_ids" {
  description = "A private subnet ID to deploy the DB instance in"
  type        = list(string)
}

# SM
variable "path" {
  description = "The path to organize secrets"
  type        = string
}
