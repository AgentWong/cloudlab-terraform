# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

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
variable "subnet_id" {
  description = "The subnet ID to deploy to"
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
variable "vpc_id" {
  description = "The VPC ID to deploy to"
  type        = string
}
variable "ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = null
}
