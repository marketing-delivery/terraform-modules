resource "aws_acm_certificate" "example" {
  provider          = aws.regional
  domain_name       = lower(var.domain_name)
  validation_method = "DNS"
}

data "aws_route53_zone" "example" {
  provider     = aws.regional
  name         = var.registered_domain
  private_zone = false
}

resource "time_sleep" "wait_for_cert" {
  count      = aws_acm_certificate.example.status == "ISSUED" ? 0 : 1
  depends_on = [aws_acm_certificate.example]

  create_duration = "90s"

  triggers = {
    certificate_arn = aws_acm_certificate.example.arn
  }
}

resource "aws_route53_record" "example" {
  provider = aws.regional
  count    = aws_acm_certificate.example.status == "ISSUED" ? 0 : 1
  depends_on = [
    time_sleep.wait_for_cert,
    aws_acm_certificate.example
  ]

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.example.zone_id
  name            = tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_value]
  ttl             = 60
  type            = tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_type
}

resource "aws_acm_certificate_validation" "example" {
  count                   = aws_acm_certificate.example.status == "ISSUED" ? 0 : 1
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [aws_route53_record.example[0].fqdn]
}