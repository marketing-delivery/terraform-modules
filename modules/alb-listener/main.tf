# lb listener (https)

resource "aws_alb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval          = "30"
    protocol          = "HTTP"
    #matcher             = "200"
    timeout             = "3"
    port                = var.container_port
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  # Add CORS support
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  tags = local.tags
}

# HTTPS listener for regular traffic
resource "aws_alb_listener" "https_forward" {
  count             = var.is_https ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.tls_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.id
  }

  tags = local.tags
}

resource "aws_alb_listener" "http" {
  count             = var.is_https ? 0 : 1
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }

  tags = local.tags
}

resource "aws_lb_listener" "http_to_https_redirect" {
  count             = var.is_https ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      query       = "#{query}"
      host        = "#{host}"
      path        = "/#{path}"
    }
  }

  tags = local.tags
}