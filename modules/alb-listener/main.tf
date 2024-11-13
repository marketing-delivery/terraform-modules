# lb listener (https)

resource "aws_alb_target_group" "this" {
    name        = "${var.name}-tg"
    port        = var.container_port
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        #matcher             = "200"
        timeout             = "3"
        port                = var.container_port
        path                = var.health_check_path
        unhealthy_threshold = "2"
    }

    tags = local.tags
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "https" {
  load_balancer_arn = var.alb_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.tls_policy
  certificate_arn   = aws_acm_certificate_validation.this.certificate_arn
  
  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }

  depends_on       = [aws_acm_certificate_validation.this]

  tags = local.tags
}


resource "aws_lb_listener" "http_to_https_redirect" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port             = "443"
      protocol         = "HTTPS"
      status_code      = "HTTP_301"
      query            = "#{query}"
      host             = "#{host}"
      path             = "/#{path}"
    }
  }

  tags = local.tags
}