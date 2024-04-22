# CloudFront certs need to be in us-east-1
provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

# certificate
data "aws_acm_certificate" "this" {
  domain      = var.domain
  statuses    = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = true
  provider = aws.virginia
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "access-identity-${var.domain}.s3.amazonaws.com"
}

# Define the CloudFront distribution
resource "aws_cloudfront_distribution" "weather_site" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = "S3-Website"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain]

  default_cache_behavior {
    allowed_methods      = ["GET", "HEAD", "OPTIONS"]
    cached_methods       = ["GET", "HEAD"]
    target_origin_id     = "S3-Website"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl              = 0
    default_ttl          = 3600
    max_ttl              = 86400

    response_headers_policy_id = var.response_headers_policy_id
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  # logging_config {
  #   bucket         = aws_s3_bucket.cf_logging_bucket.bucket_domain_name
  #   include_cookies = false
  #   prefix         = "weather.marketingdelivery.net/"
  # }

  tags = merge(var.tags, { "Name" = var.domain })
}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn
        },
        "Action": "s3:GetObject",
        "Resource": "${var.bucket_arn}/*"
      }
    ]
  })
}