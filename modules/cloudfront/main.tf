# If a domain is specified then check for it's certificate
data "aws_acm_certificate" "this" {
  count       = var.domain != "" ? 1 : 0
  provider    = aws.global
  domain      = var.domain
  statuses    = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = true
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "access-identity-${var.domain}.s3.amazonaws.com"
}

locals {
  certificate_arn = var.domain != "" ? data.aws_acm_certificate.this[0].arn : ""
  aliases         = var.domain != "" ? [var.domain] : []
}

# Define the CloudFront distribution
resource "aws_cloudfront_distribution" "this" {
  depends_on = [data.aws_acm_certificate.this]

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = "S3-Website"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  provider = aws.global

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Optionally add the web_acl_id if it's specified
  web_acl_id = var.web_acl_id != "" ? var.web_acl_id : null

  aliases = local.aliases

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-Website"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    response_headers_policy_id = var.response_headers_policy_id

    dynamic "lambda_function_association" {
      for_each = var.lambda_arn == "" ? [] : [1]
      content {
        event_type   = "viewer-request"
        lambda_arn   = var.lambda_arn
        include_body = false
      }
    }

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn            = local.certificate_arn
    cloudfront_default_certificate = local.certificate_arn == "" ? true : false
    ssl_support_method             = local.certificate_arn == "" ? null : "sni-only"
    minimum_protocol_version       = local.certificate_arn == "" ? null : "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
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
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn
        },
        "Action" : "s3:GetObject",
        "Resource" : "${var.bucket_arn}/*"
      },
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
}