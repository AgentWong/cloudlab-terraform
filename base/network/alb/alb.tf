resource "aws_alb" "this" {
  name            = "${var.alb_name}-alb"
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.alb.id]
  internal        = false
  tags = {
    Name = var.alb_name
  }
}
resource "aws_lb_target_group" "this" {
  name        = "${var.alb_name}-tg"
  port        = 80
  target_type = "instance"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = 80
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "${var.alb_name}-target-group"
  }
}
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
