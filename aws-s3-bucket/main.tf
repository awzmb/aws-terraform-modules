terraform {
  required_providers {
    aws = "> 3.0"
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
  tags          = var.tags
  force_destroy = var.enable_bucket_force_destroy
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket.bucket,
    aws_s3_bucket_public_access_block.public_access_block,
    aws_s3_bucket_ownership_controls.bucket_acl_ownership
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "s3_kms_key" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
