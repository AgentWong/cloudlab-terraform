# KMS
output "key_name" {
    value = module.kms.key_name
}

# VPC
output "public_subnets" {
    value = module.vpc.public_subnets
}
output "private_subnets" {
    value = module.vpc.private_subnets
}
output "vpc_id" {
    value = module.vpc.vpc_id
}