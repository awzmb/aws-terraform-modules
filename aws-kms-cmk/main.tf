terraform {
  required_providers {
    aws = "> 3.0"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "cmk" {
  description              = "Default key for EC2 access"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  multi_region        = true
  enable_key_rotation = true

  policy = jsonencode({
    Id = "DefaultKeyPolicy"
    Statement = [
      {
        Sid    = "Enable root access and prevent permission delegation"
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Condition = {
          "StringEquals" = {
            "aws:PrincipalType" = "Account"
          }
        }
      },
      {
        Sid    = "Give full access to Admin and AtlantisTerraformRole"
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AtlantisTerraformRole"
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSAdministratorAccess"
        }
        Resource = "*"
      },
      {
        Sid = "Enable read access to all identities"
        Action = [
          "kms:List*",
          "kms:Get*",
          "kms:Describe*"
        ]
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })

  tags = var.tags
}

resource "aws_kms_alias" "cmk_alias" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.cmk.key_id
}

