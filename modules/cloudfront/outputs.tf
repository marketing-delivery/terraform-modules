output "arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "id" {
  value = aws_cloudfront_distribution.this.id
}

output "url" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "zone_id" {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}