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
variable "instance_count" {
  description = "The number of instances to deploy"
  type        = number
}
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}
variable "key_name" {
  description = "The EC2 keypair to use"
  type        = string
}
variable "operating_system" {
  description = "The OS type, either Windows or Linux"
  type        = string
  validation {
    condition     = var.operating_system == "Windows" || var.operating_system == "Linux"
    error_message = "Must be either Windows or Linux"
  }
}
variable "subnet_id" {
  description = "The subnet ID to deploy to"
  type        = string
}
variable "vpc_id" {
  description = "The VPC ID to deploy to"
  type        = string
}
variable "security_group_ids" {
  description = "The security group id to associate with the instances"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "get_password_data" {
  description = "Whether or not to get password for Windows instances"
  type        = bool
  default     = false
}
variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = null
}
variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}
