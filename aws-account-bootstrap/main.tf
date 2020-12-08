terraform {
  required_providers {
    aws = "~> 3.0"
  }
}

locals {
  bucket_name = "${var.account_alias}-${var.bucket_purpose}-${var.region}"
  table_name  = "${var.account_alias}-${var.bucket_purpose}-${var.region}-lock"
}

resource "aws_iam_account_alias" "alias" {
  account_alias = var.account_alias
}

module "statefile_bucket" {
  source = "github.com/awzmb/aws-terraform-modules/aws-s3-bucket"

  bucket_name              = local.bucket_name
  use_account_alias_prefix = false
  tags                     = var.tags
}

resource "aws_dynamodb_table" "statefile_lock" {
  name           = local.table_name
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2
  tags           = var.tags

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
