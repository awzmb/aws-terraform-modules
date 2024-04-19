terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "public_access_allow" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configuration" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "access_from_internet" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_read_access_from_internet.json

  depends_on = [
    aws_s3_bucket_public_access_block.public_access_allow
  ]
}

data "aws_iam_policy_document" "allow_read_access_from_internet" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement	{
		sid = "PutWebsiteContent"

		principals {
      type = "AWS"
      identifiers = var.bucket_users
    }

		actions = [ 
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"      
    ]

		resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}