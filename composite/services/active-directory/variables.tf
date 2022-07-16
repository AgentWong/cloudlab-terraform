# Ansible vars
variable "ansible_bastion_public_dns" {
  description = "Public DNS name of the Ansible bastion host"
  type        = string
}
variable "domain_name" {
  description = "The domain name"
  type        = string
}
variable "netbios" {
  description = "The netbios name"
  type        = string
}

# EC2
variable "environment" {
  description = "The current environment"
  type        = string
}
variable "ansible_winrm_sg_id" {
  description = "The SG id to allow WinRM access"
  type        = string
}
variable "key_name" {
  description = "The keyname"
  type        = string
}
variable "pdc_subnet_cidr" {
  description = "A private subnet ID to deploy the instance in"
  type        = string
}
variable "pdc_subnet_id" {
  description = "A private subnet ID to deploy the instance in"
  type        = string
}
variable "rdc_subnet_cidr" {
  description = "A private subnet ID to deploy the instance in"
  type        = string
}
variable "rdc_subnet_id" {
  description = "A private subnet ID to deploy the instance in"
  type        = string
}
variable "region" {
  description = "The region this is running in"
  type        = string
}
variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

# SM
variable "path" {
  description = "The Secrets path"
  type        = string
}
