# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}
variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}
variable "prefix_name" {
  description = "Name of the environment."
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR range for the VPC."
  type        = string
}
variable "tgw_cidr" {
  description = "CIDR range for the transit gateway."
  type        = string
}
variable "region" {
  description = "Region"
  type        = string
}
