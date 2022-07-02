resource "aws_launch_configuration" "this" {
  image_id        = data.aws_ami.instance.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  key_name        = var.key_name
  user_data       = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "this" {
  name = "${var.cluster_name}-asg-${aws_launch_configuration.this.name}"

  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = var.target_group_arns
  health_check_type    = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  min_elb_capacity = var.min_size

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 1
  max_size               = 5
  desired_capacity       = 3
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name = "${var.cluster_name}-scale-in-at-night"
  min_size              = 1
  max_size              = 3
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = aws_autoscaling_group.this.name
}
