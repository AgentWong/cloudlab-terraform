resource "aws_lb_target_group_attachment" "this" {
  for_each         = var.instance_ids != null ? { for k, v in var.instance_ids : k => v } : {}
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
}
