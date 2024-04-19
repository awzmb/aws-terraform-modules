terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  account_id = "666176242440"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ec2_atlantis_iam_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::*:role/AtlantisTerraformRole",
    ]
  }
}

resource "aws_iam_policy" "ec2_atlantis_iam_policy" {
  name   = "AtlantisEC2AllowAssumingTerraformRole"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2_atlantis_iam_policy_document.json
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "AtlantisEC2SessionManager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2AssumeRole"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Sid    = "AllowSSMAssumeRole"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "ec2_ssm_iam_policy" {
  name        = "AtlantisEC2SSMPolicy"
  path        = "/"
  description = "Allow SSM communication for EC2"

  tags = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowBasicSSMCommunication"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "AllowCloudWatchLogsAccess"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "GetS3EncryptionInformation"
        Action = [
          "s3:GetEncryptionConfiguration"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "AllowAccessToKMSKeyForEC2"
        Action = [
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = var.key_arn
      },
      {
        Sid = "AllowKMSGenerateDataKey"
        Action = [
          "s3:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "AllowS3GetForSSM"
        Action = [
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::aws-ssm-region/*",
          "arn:aws:s3:::aws-windows-downloads-region/*",
          "arn:aws:s3:::amazon-ssm-region/*",
          "arn:aws:s3:::amazon-ssm-packages-region/*",
          "arn:aws:s3:::region-birdwatcher-prod/*",
          "arn:aws:s3:::aws-ssm-distributor-file-region/*",
          "arn:aws:s3:::aws-ssm-document-attachments-region/*",
          "arn:aws:s3:::patch-baseline-snapshot-region/*"
        ]
      },
      {
        Sid = "AllowS3PutForSSM"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetEncryptionConfiguration"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ssm_communication" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.ec2_ssm_iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ec2_atlantisterraformrole" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.ec2_atlantis_iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ssm_managed_core" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ec2_instance_connect" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = var.name
  role = aws_iam_role.ec2_iam_role.name
}


resource "aws_iam_policy" "sops_key_policy" {
  name        = "AtlantisEC2SOPSPolicy"
  path        = "/"
  description = "Allow SOPS Key Access for EC2"

  tags = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowAccessToSOPSKeyForEC2"
        Action = [
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = var.key_sops_arn
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "policy_attachment_ec2_sops_key" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.sops_key_policy.arn
}
