# lb main definition
resource "aws_lb" "this" {
  name = var.name
  #internal                   = false
  #security_groups            = aws_security_group.alb_sg.id
  security_groups = [var.security_group_id]
  subnets         = var.vpc_subnets
  # idle_timeout               = var.idle_timeout
  # enable_deletion_protection = var.enable_deletion_protection
  # drop_invalid_header_fields = var.drop_invalid_header_fields
  # desync_mitigation_mode     = var.desync_mitigation_mode

  # dynamic "access_logs" {
  #   for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]
  #   content {
  #     bucket  = lookup(access_logs.value, "bucket", "${var.lb_name}-lb-logs")
  #     enabled = lookup(access_logs.value, "enabled", true)
  #   }
  # }
  tags = local.tags
}