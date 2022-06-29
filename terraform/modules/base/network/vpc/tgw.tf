resource "aws_ec2_transit_gateway" "this" {
    description = "Transit gateway for ${var.prefix_name}"
    auto_accept_shared_attachments = "disable"
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    dns_support = "enable"
    vpn_ecmp_support = "enable"
    tags = {
        Name = "tgw-${var.prefix_name}"
    }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
    transit_gateway_id = aws_ec2_transit_gateway.this.id
    vpc_id = aws_vpc.this.id
    dns_support = "enable"
    subnet_ids = values(aws_subnet.public_subnets)[*].id
    tags = {
        Name = "tgw-${var.prefix_name}-subnet"
    }
}
resource "aws_route" "tgw_route" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = var.tgw_cidr
  transit_gateway_id = aws_ec2_transit_gateway.this.id
}