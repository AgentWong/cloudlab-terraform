#Create VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.prefix_name}_${var.region}"
  }
}
#Get all available AZ's in region
data "aws_availability_zones" "this" {
  state = "available"

  # Exclude local availability zones.
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

#Create IGW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.prefix_name}_${var.region}-igw"
  }
}
