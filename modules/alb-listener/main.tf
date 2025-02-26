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

# HTTPS listener for CORS preflight requests
resource "aws_alb_listener" "https_cors" {
  count             = var.is_https && var.enable_cors ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.tls_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "CORS preflight request"
      status_code  = "200"
    }
  }

  tags = local.tags
}

# HTTPS listener for regular traffic
resource "aws_alb_listener" "https_forward" {
  count             = var.is_https && !var.enable_cors ? 1 : 0
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

# Rule for OPTIONS preflight requests
resource "aws_lb_listener_rule" "options_preflight" {
  count        = var.is_https && var.enable_cors ? 1 : 0
  listener_arn = aws_alb_listener.https_cors[0].arn
  priority     = 1

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "204"
      message_body = ""
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    http_request_method {
      values = ["OPTIONS"]
    }
  }
}

resource "aws_lb_listener_rule" "api_forward" {
  count        = var.is_https && !var.enable_cors ? 1 : 0
  listener_arn = aws_alb_listener.https_forward[0].arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    http_request_method {
      values = ["GET", "POST", "PUT", "DELETE"]
    }
  }
}

# First rule for GET, POST, PUT
resource "aws_lb_listener_rule" "api_cors_1" {
  count        = var.is_https && var.enable_cors ? 1 : 0
  listener_arn = aws_alb_listener.https_cors[0].arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    http_request_method {
      values = ["GET", "POST", "PUT"]
    }
  }
}

# Second rule for DELETE and OPTIONS
resource "aws_lb_listener_rule" "api_cors_2" {
  count        = var.is_https && var.enable_cors ? 1 : 0
  listener_arn = aws_alb_listener.https_cors[0].arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    http_request_method {
      values = ["DELETE", "OPTIONS"]
    }
  }
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