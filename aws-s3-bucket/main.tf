terraform {
  required_providers {
    aws = "~> 3.0"
  }
}

data "aws_iam_account_alias" "current" {
  count = var.use_account_alias_prefix ? 1 : 0
}
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

locals {
  bucket_prefix = var.use_account_alias_prefix ? format("%s-", data.aws_iam_account_alias.current[0].account_alias) : ""
  bucket_id     = "${local.bucket_prefix}${var.bucket_name}"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket_id
  acl           = "private"
  tags          = var.tags
  force_destroy = var.enable_bucket_force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
