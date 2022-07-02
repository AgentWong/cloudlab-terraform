# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}
variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}
variable "prefix_name" {
  type        = string
  description = "Name of the environment."
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR range for the VPC."
}
variable "tgw_cidr" {
  type        = string
  description = "CIDR range for the transit gateway."
}
variable "region" {
  type        = string
  description = "Region"
}
