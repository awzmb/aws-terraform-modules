terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  account_id              = "666176242440"
  principal_sso_role_name = "AWSAdministratorAccess"
}
data "aws_caller_identity" "current" {}

data "aws_iam_policy" "iam_policy_administrator_access" {
  name = "AdministratorAccess"
}

# allow administrative access via assumerole from terraform account
# NOTE: as we are using IAM Identity Center (SSO) for access, we have
# to specifically allow SSO users by ARN to allow them to assume roles
# https://stackoverflow.com/questions/73639007/allow-user-to-assume-an-iam-role-with-sso-login
data "aws_iam_policy_document" "terraform_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:role/AtlantisEC2SessionManager"
      ]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:root"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${local.account_id}:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_${local.principal_sso_role_name}_*",
        "arn:aws:iam::${local.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_${local.principal_sso_role_name}_*"
      ]
    }
  }
}

resource "aws_iam_role" "assume_role" {
  name                = "AtlantisTerraformRole"
  assume_role_policy  = data.aws_iam_policy_document.terraform_assume_role_policy_document.json
  managed_policy_arns = [data.aws_iam_policy.iam_policy_administrator_access.arn]

  tags = var.tags
}
