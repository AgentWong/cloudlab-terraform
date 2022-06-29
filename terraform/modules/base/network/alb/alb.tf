resource "aws_alb" "this" {
    name = var.alb_name
    subnets = [values(var.public_subnets)[0].id,values(var.public_subnets)[1].id]
    security_groups = ["${aws_security_group.alb.id}"]
    internal = false
    tags = {
        Name = var.alb_name
    }
}