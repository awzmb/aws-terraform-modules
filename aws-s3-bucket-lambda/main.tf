terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  role_name     = "lambda-${var.bucket_name}-function-role"
  iam_user_name = "lambda-${var.bucket_name}-iam-user"
  policy_name   = "lambda-${var.bucket_name}-iam-policy"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_iam_role" "role" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLambda"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_lambda_execution_role" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_s3_bucket_public_access_block" "public_access_deny" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  # content will be pushed from bitbucket, so there is no need for another history
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json

  depends_on = [
    aws_s3_bucket_public_access_block.public_access_deny
  ]
}

data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    sid = "AllowAccessFromLambdaService"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.role.arn]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement {
    sid = "ReadWriteWithIAMUser"

    principals {
      type        = "AWS"
      identifiers = aws_iam_user.iam_user
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

resource "aws_iam_user" "iam_user" {
  name = local.iam_user_name
  path = "/"

  tags = var.tags
}

data "aws_iam_policy_document" "iam_user_s3_policy_document" {
  statement {
    effect = "Allow"

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

resource "aws_iam_user_policy" "iam_user_s3_policy" {
  name   = local.policy_name
  user   = aws_iam_user.iam_user.name
  policy = data.aws_iam_policy_document.iam_user_s3_policy_document.json
}
