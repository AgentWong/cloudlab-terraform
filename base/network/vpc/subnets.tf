#Create public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = toset(var.public_subnets)
  availability_zone       = element(data.aws_availability_zones.this.names, index(var.public_subnets, each.value))
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix_name}_${element(data.aws_availability_zones.this.names, index(var.public_subnets, each.value))}_public"
  }
}
#Create private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = toset(var.private_subnets)
  availability_zone = element(data.aws_availability_zones.this.names, index(var.private_subnets, each.value))
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  tags = {
    Name = "${var.prefix_name}_${element(data.aws_availability_zones.this.names, index(var.private_subnets, each.value))}_private"
  }
}
