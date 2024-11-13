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
  domain     = var.domain_name
  statuses   = ["PENDING_VALIDATION"]
  depends_on = [aws_acm_certificate.this]
}

# Add the missing Route53 record resource for certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = var.route53_zone_id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}