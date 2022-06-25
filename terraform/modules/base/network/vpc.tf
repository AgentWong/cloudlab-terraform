### ACG Regions are us-east-1 and us-west-2 ###

#Create VPC in us-west-2
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}_${var.region}"
  }
}
#Get all available AZ's in VPC for master region
data "aws_availability_zones" "this" {
  state = "available"
}

#Create IGW in us-west-2
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}_${var.region}-igw"
  }
}
