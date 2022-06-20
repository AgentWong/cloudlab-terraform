#Create VPC in us-east-1
resource "aws_vpc" "vpc_useast" {
  provider             = aws.default
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eden-vpc"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_useast.id
}