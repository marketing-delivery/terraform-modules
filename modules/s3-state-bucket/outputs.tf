output "bucket_arn" {
  description = "s3 bucket arn"
  value       = aws_s3_bucket.this.arn
}

output "id" {
  value = aws_s3_bucket.this.id
}

output "bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.this.id
}

output "bucket_region" {
  description = "s3 bucket region"
  value       = aws_s3_bucket.this.region
}