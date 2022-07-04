# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------


variable "ami_name" {
  description = "The AMI image name, include any wildcards"
  type        = string
}
variable "ami_owner" {
  description = "The owner ID or alias for the account that owns the AMI"
  type        = string
}
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}
variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
}
variable "ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
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
variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}
variable "target_group_arns" {
  description = "The ARNs of load balancer target groups in which to register Instances"
  type        = list(string)
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "security_group_id" {
  description = "The security group id to associate with the instances"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
  default     = false
}
variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}
