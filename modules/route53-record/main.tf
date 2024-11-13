resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags             = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Use a `null_resource` to trigger the certificate's validation once its options are populated.
#resource "null_resource" "certificate_delay" {
#  depends_on = [aws_acm_certificate.this]
#}

data "aws_acm_certificate" "this" {
  domain          = var.domain_name
  statuses        = ["PENDING_VALIDATION"]

  # Ensure this data lookup waits until the certificate is created
  depends_on = [aws_acm_certificate.this]
}



resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  # Adding dependency to ensure domain validation options are created
  depends_on       = [data.aws_acm_certificate.this]

  allow_overwrite  = true
  name             = each.value.name
  records          = [each.value.record]
  ttl              = 60
  type             = each.value.type
  zone_id          = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "alias" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}