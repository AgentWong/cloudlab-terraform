output "public_subnet_cidr_blocks" {
  value = values(aws_subnet.public_subnets)[*].cidr_block
}
output "private_subnet_cidr_blocks" {
  value = values(aws_subnet.private_subnets)[*].cidr_block
}
output "public_subnet_ids" {
  value = values(aws_subnet.public_subnets)[*].id
}
output "private_subnet_ids" {
  value = values(aws_subnet.private_subnets)[*].id
}
output "vpc_id" {
  value = aws_vpc.this.id
}
