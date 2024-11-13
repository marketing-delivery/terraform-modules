resource "aws_acm_certificate" "example" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

data "aws_route53_zone" "example" {
  name         = var.registered_domain
  private_zone = false
}

resource "null_resource" "certificate_delay" {
  depends_on = [aws_acm_certificate.example]
}


resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  depends_on       = [null_resource.certificate_delay]  # Ensures certificate options are available
  allow_overwrite  = true
  name             = each.value.name
  records          = [each.value.record]
  ttl              = 60
  type             = each.value.type
  zone_id          = data.aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}