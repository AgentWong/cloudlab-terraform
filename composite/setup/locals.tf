locals {
  vpc_cidr = regex("\\b(?:\\d{1,3}.){1}\\d{1,3}\\b", var.vpc_cidr)
}
