terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_ecs_cluster" "ecs_fargate_cluster" {
  name = "${var.name}-ecs-cluster"

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "ecs_fargate_capacity_provider" {
  cluster_name = aws_ecs_cluster.ecs_fargate_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# policies
data "aws_iam_policy_document" "ecs_tasks_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "ECSTaskExecutionRoleFor${var.name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json
  path               = "/"

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ref: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data.html
#data "aws_iam_policy_document" "ecs_task_access_secrets" {
#statement {
#effect = "Allow"

#resources = ["*"]

#actions = [
#"ssm:GetParameters",
#"secretsmanager:GetSecretValue",
#]
#}
#}

#data "aws_iam_policy_document" "ecs_task_access_secrets_with_kms" {
#source_json = data.aws_iam_policy_document.ecs_task_access_secrets.json

#statement {
#sid       = "AllowKMSDecrypt"
#effect    = "Allow"
#actions   = ["kms:Decrypt"]
#resources = [var.ssm_kms_key_arn]
#}
#}

#resource "aws_iam_role_policy" "ecs_task_access_secrets" {
#name = "ECSTaskAccessSecretsPolicy"

#role = aws_iam_role.ecs_task_execution.id

#policy = element(
#compact(
#concat(
#data.aws_iam_policy_document.ecs_task_access_secrets_with_kms[*].json,
#data.aws_iam_policy_document.ecs_task_access_secrets[*].json,
#),
#),
#0,
#)
#}
