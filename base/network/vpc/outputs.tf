output "public_subnets" {
    value = tolist(values(aws_subnet.public_subnets)[*].id)
}
output "private_subnets" {
    value = tolist(values(aws_subnet.private_subnets)[*].id)
}
output "vpc_id" {
    value = aws_vpc.this.id
}