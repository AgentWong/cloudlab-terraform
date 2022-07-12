# Ansible vars
variable "domain_name" {
  description = "The domain name"
  type        = string
}
variable "netbios" {
  description = "The netbios name"
  type        = string
}

# EC2
variable "ansible_winrm_sg_id" {
  description = "The SG id to allow WinRM access"
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
