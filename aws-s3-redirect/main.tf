terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configuration" {
  bucket = aws_s3_bucket.bucket.id

  redirect_all_requests_to {
    host_name = var.redirect_bucket_name
    protocol  = "https"
  }
}


