terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  name_prefix = "budget-slack-notifier"
}

# ---------- ROLLE ---------------

resource "aws_iam_role" "role" {
  name = "${local.name_prefix}-lambda-role"

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

data "aws_iam_policy_document" "lambda_allow_decrypt_policy_document" {
  statement {
    sid       = "AllowUsageByLambdaFunction"
    effect    = "Allow"
    resources = [aws_kms_key.slack_url_encryptor.arn]
    actions   = ["kms:Decrypt"]
  }
}

resource "aws_iam_role_policy" "lambda_allow_decrypt_policy" {
  name   = "${local.name_prefix}-kms-policy"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.lambda_allow_decrypt_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_lambda_execution_role" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# ---------- LAMBDA ---------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "slack_notifier.py"
  output_path = "slack_notifier.zip"
  # TODO: how do we create the .zip in the pipeline itself?
}

resource "aws_kms_ciphertext" "slack_url" {
  key_id = aws_kms_key.slack_url_encryptor.key_id

  plaintext = var.decrypted_slack_webhook_url

}

resource "aws_kms_ciphertext" "slack_channel" {
  key_id = aws_kms_key.slack_url_encryptor.key_id

  plaintext = var.slack_channel
}

resource "aws_lambda_function" "budget_notifier" {
  #checkov:skip=CKV_AWS_50:We don't need X-Ray tracing, we're not doing anything performance-sensitive
  #checkov:skip=CKV_AWS_117:We don't need access to anything within the VPC, so we don't assign one
  #checkov:skip=CKV_AWS_116:Do we actually need a dead-letter-queue?
  #checkov:skip=CKV_AWS_272:We don't need code signing, at this stage
  #checkov:skip=CKV_AWS_115:Currently, we do not want to touch account-wide concurrency limits
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda.output_path
  function_name = "${local.name_prefix}-function"
  role          = aws_iam_role.role.arn
  handler       = "slack_notifier.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  kms_key_arn = aws_kms_key.slack_url_encryptor.arn

  environment {
    variables = {
      slackChannel        = aws_kms_ciphertext.slack_channel.ciphertext_blob
      kmsEncryptedHookUrl = aws_kms_ciphertext.slack_url.ciphertext_blob
    }
  }

  tags = var.tags
}


# ---------- KMS ---------------

resource "aws_kms_key" "slack_url_encryptor" {
  description = "Key for encrypting the Slack URL for use in the Slack Notifier Lambda"
  key_usage   = "ENCRYPT_DECRYPT"

  enable_key_rotation = true

  tags = var.tags
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "slack_url_encryptor_policy_data" {
  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = [aws_kms_key.slack_url_encryptor.arn]
  }

  statement {
    sid    = "AllowKeyAccessToCaller"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = [aws_kms_key.slack_url_encryptor.arn]
  }

  statement {
    sid    = "AllowKeyUsageByLambdaExecutionRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.role.arn]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.slack_url_encryptor.arn]
  }

  statement {
    sid    = "AllowGrantsForAWSResources"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.role.arn]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = [aws_kms_key.slack_url_encryptor.arn]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  ## Allow user to send messages to the topic
  statement {
    sid    = "AllowSNStoAccessToKey"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com", "budgets.amazonaws.com", "costalerts.amazonaws.com"]
    }
    resources = [aws_kms_key.slack_url_encryptor.arn]
  }
}

resource "aws_kms_key_policy" "slack_url_encryptor_policy" {
  key_id = aws_kms_key.slack_url_encryptor.id

  policy = data.aws_iam_policy_document.slack_url_encryptor_policy_data.json
}


# ---------- BUDGET ---------------

resource "aws_budgets_budget" "base_budget" {
  name              = "${local.name_prefix}-monthly-budget"
  budget_type       = "COST"
  limit_amount      = var.budget_amount
  limit_unit        = var.budget_unit
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2020-01-01_00:00"
  time_unit         = var.budget_time_unit

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_notifications.arn]
  }
}


# ---------- COST ANOMALY MONITOR ---------------

resource "aws_ce_anomaly_monitor" "service_monitor" {
  name              = "${local.name_prefix}-ce-anomaly-service-monitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "anomaly_subscription" {
  name = "${local.name_prefix}-ce-anomaly-subscription"

  threshold_expression {
    dimension {
      # alternative would be to use ANOMALY_TOTAL_IMPACT_PERCENTAGE
      # instead, based on the usual costs
      key = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      # use an absolute amount (double the budget limit)
      values        = [tonumber(var.budget_amount * 2)]
      match_options = ["GREATER_THAN_OR_EQUAL"]
    }
  }

  # this is required for alerts to be sent to SNS
  frequency = "IMMEDIATE"

  monitor_arn_list = [aws_ce_anomaly_monitor.service_monitor.arn]

  subscriber {
    type    = "SNS"
    address = aws_sns_topic.budget_notifications.arn
  }

  tags = var.tags
}


# ---------- SNS ---------------

resource "aws_sns_topic" "budget_notifications" {
  name = "${local.name_prefix}-topic"

  policy            = data.aws_iam_policy_document.sns_topic_access_policy.json
  kms_master_key_id = aws_kms_key.slack_url_encryptor.arn

  tags = var.tags
}


data "aws_iam_policy_document" "sns_topic_access_policy" {
  statement {
    sid       = "DefaultStatement"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [data.aws_caller_identity.current.account_id]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
  statement {
    sid       = "AllowAWSBudgetAlerts"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com", "costalerts.amazonaws.com"]
    }
  }
}


# ---------- SNS Subscription ---------------

resource "aws_sns_topic_subscription" "slack_subscription" {
  topic_arn = aws_sns_topic.budget_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.budget_notifier.arn
}


resource "aws_lambda_permission" "allow_execution_from_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.budget_notifier.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.budget_notifications.arn
}

# ---------- Logging ---------------
#
# the AWSLambdaBasicExecutionRole already allows writing to CloudWatch Logs
