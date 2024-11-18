resource "aws_acm_certificate" "example" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

data "aws_route53_zone" "example" {
  name         = var.registered_domain
  private_zone = false
}

resource "time_sleep" "wait_for_cert" {
  depends_on = [aws_acm_certificate.example]

  create_duration = "90s"

  triggers = {
    # This will re-run the wait if the certificate ARN changes
    certificate_arn = aws_acm_certificate.example.arn
  }
}

#resource "aws_route53_record" "example" {
#  depends_on = [
#    time_sleep.wait_for_cert,
#    aws_acm_certificate.example
#  ]
#  
#  allow_overwrite = true
#  zone_id         = data.aws_route53_zone.example.zone_id
#  name            = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
#  records         = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
#  ttl             = 60
#  type            = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
#}

#resource "aws_acm_certificate_validation" "example" {
#  certificate_arn         = aws_acm_certificate.example.arn
#  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
#}