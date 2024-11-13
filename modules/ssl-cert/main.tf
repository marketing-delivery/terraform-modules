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

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}