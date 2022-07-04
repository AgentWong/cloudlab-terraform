# KMS
variable "key_name" {
  description = "The keyname"
  type        = string
}
variable "public_key" {
  description = "The public key material"
  type        = string
}

# VPC
variable "prefix_name" {
  description = "Name of the environment."
  type        = string
}
variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}
variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}
variable "region" {
  description = "Region"
  type        = string
}
variable "tgw_cidr" {
  description = "CIDR range for the transit gateway."
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR range for the VPC."
  type        = string
}