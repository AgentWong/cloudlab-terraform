variable "alb_name" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "instance_ids" {
  description = "The instance ids for the target group"
  type        = list(string)
  default     = null
}
variable "ingress_ports" {
  description = "A list of port numbers to allow ingress traffic"
  type        = list(number)
}