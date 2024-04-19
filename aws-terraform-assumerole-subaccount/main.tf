terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  principal_sso_role_name = "AWSAdministratorAccess"
}

data "aws_iam_policy" "iam_policy_administrator_access" {
  name = "AdministratorAccess"
}

# allow administrative access via assumerole from terraform account
data "aws_iam_policy_document" "terraform_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.terraform_account_id}:role/AtlantisTerraformRole"
      ]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.terraform_account_id}:role/AtlantisEC2SessionManager"
      ]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.terraform_account_id}:root"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${var.terraform_account_id}:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_${local.principal_sso_role_name}_*",
        "arn:aws:iam::${var.terraform_account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_${local.principal_sso_role_name}_*"
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
