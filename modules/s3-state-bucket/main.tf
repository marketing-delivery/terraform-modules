resource "random_string" "suffix" {
  upper   = false
  special = false
  length  = 4

  keepers = {
    lifecycle = terraform.workspace
  }
}

locals {
  name = var.has_random_suffix == true ? "${var.name}-${random_string.suffix.id}" : var.name
}

resource "aws_s3_bucket" "this" {
  bucket        = local.name
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [for account_id in var.account_ids : {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${account_id}:root"
        }
        Action = "s3:*"
        Resource = [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*"
        ]
      }],
      [{
        Sid       = "AllowSSLRequestsOnly_uqwhmy"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*"
        ]
      }]
    )
  })
}

