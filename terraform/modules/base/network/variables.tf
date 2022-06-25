variable "vpc_cidr" {
  type        = string
  description = "CIDR range for the VPC."
  default     = null
}
variable "vpc_name" {
  type        = string
  description = "Name of the VPC."
  default     = null
}
variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}
variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}
variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}
