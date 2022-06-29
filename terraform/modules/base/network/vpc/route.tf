#Create public route table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.prefix_name}_${var.region}-public-rt"
  }
}

#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_main_route_table_association" "public_rt_assoc" {
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.public_route.id
}

#Create association between route table and public subnets
resource "aws_route_table_association" "public_association" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route.id
}
