# Ansible vars
variable "ansible_bastion_private_ip" {
  description = "Private IP of the Ansible bastion host"
  type        = string
}
variable "linux_bastion_public_dns" {
  description = "Public DNS name of the Linux bastion host"
  type        = string
}
variable "domain_name" {
  description = "The domain name"
  type        = string
}
variable "distinguished_name" {
  description = "The domain distinguished name"
  type        = string
}
variable "ec2_keypair_secret_id" {
  description = "EC2 keypair secret id"
  type        = string
}
variable "radmin_password_id" {
  description = "The radmin account password id"
  type        = string
}
variable "org_name" {
  description = "Organization Name"
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
variable "private_subnet_cidrs" {
  description = "A private subnet ID to deploy the instance in"
  type        = list(string)
}
variable "private_subnet_ids" {
  description = "A private subnet ID to deploy the instance in"
  type        = list(string)
}
variable "region" {
  description = "The region this is running in"
  type        = string
}
variable "vpc_cidr" {
  description = "The VPC cidr first 2 octets"
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
