output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.example.arn
}

output "validation_record_name" {
  description = "The name of the DNS record for certificate validation"
  value       = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
}

output "validation_record_value" {
  description = "The value of the DNS record for certificate validation"
  value       = aws_acm_certificate.example.domain_validation_options[0].resource_record_value
}

output "validation_record_type" {
  description = "The type of DNS record for certificate validation"
  value       = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
}