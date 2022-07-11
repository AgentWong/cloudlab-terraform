output "instance_ids" {
  value = values(aws_instance.this)[*].id
}
output "public_ips" {
  value = values(aws_instance.this)[*].public_ip
}
output "primary_network_interface_ids" {
  value = values(aws_instance.this)[*].primary_network_interface_id
}
output "private_ips" {
  value = values(aws_instance.this)[*].private_ip
}