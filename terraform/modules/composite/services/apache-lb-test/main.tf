module "ec2" {
    source = "../../../base/ec2"

    user_data = var.user_data
    instance_name = var.instance_name
    ami_owner = var.ami_owner
    ami_name = var.ami_name
    subnet_id = var.subnet_id
}
module "alb" {
    source = "../../../base/network/alb"

    alb_name = var.alb_name
    public_subnets = var.public_subnets
    vpc_id = var.vpc_id
}