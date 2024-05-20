resource "random_string" "suffix" {
  upper   = false
  special = false
  length  = 4

  keepers = {
    lifecycle = terraform.workspace
  }
}

locals{
  name = var.has_random_suffix == true ? "${var.name}-${random_string.suffix.id}" : var.name
}

resource "aws_s3_bucket" "this" {
  bucket = local.name
  tags = var.tags
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}