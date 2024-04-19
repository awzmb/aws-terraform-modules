terraform {
  required_providers {
    aws = "> 3.0"
    http = {
      source = "hashicorp/http"
    }
  }
}

data "http" "bitbucket_ips" {
  url = "https://ip-ranges.atlassian.com/"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  service_name         = "atlantis"
  container_cpu        = 1
  container_memory     = 2048
  bitbucket_ipv4_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) == 0]
  bitbucket_ipv6_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) > 0]
}

# fetch data from vpc per id
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  depends_on = [module.alb]

  family                   = "service"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = module.custom_container_definition.json_map_encoded_list
  # TODO: ephemeral storage
}

module "custom_container_definition" {
  # docs: https://github.com/cloudposse/terraform-aws-ecs-container-definition/blob/main/docs/terraform.md
  source         = "github.com/cloudposse/terraform-aws-ecs-container-definition//."
  container_name = var.name

  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  container_image  = var.image

  port_mappings = [
    {
      name          = "${var.name}-port"
      containerPort = var.atlantis_port
      hostPort      = var.atlantis_port
      protocol      = "tcp"
    }
  ]

  #log_configuration = {
  #logDriver = "awslogs"
  #}

  environment = [
    #{
    #name  = "ATLANTIS_ALLOW_REPO_CONFIG"
    #value = var.allow_repo_config
    #},
    #{
    #name  = "ATLANTIS_LOG_LEVEL"
    #value = var.atlantis_log_level
    #},
    {
      name  = "ATLANTIS_PORT"
      value = var.atlantis_port
    },
    {
      name  = "ATLANTIS_ATLANTIS_URL"
      value = var.atlantis_url
    },
    #{
    #name  = "ATLANTIS_BITBUCKET_USER"
    #value = var.atlantis_bitbucket_user
    #},
    {
      name  = "ATLANTIS_BITBUCKET_BASE_URL"
      value = var.atlantis_bitbucket_base_url
    },
    {
      name  = "ATLANTIS_REPO_ALLOWLIST"
      value = join(",", var.atlantis_repo_allowlist)
    },
    {
      name  = "ATLANTIS_HIDE_PREV_PLAN_COMMENTS"
      value = "true"
    },
    {
      name  = "ATLANTIS_WEB_BASIC_AUTH"
      value = "true"
    },
    {
      name  = "ATLANTIS_AUTOPLAN_MODULES"
      value = "true"
    },
    {
      name  = "ATLANTIS_AUTOMERGE"
      value = "true"
    },
    {
      name  = "ATLANTIS_WEB_USERNAME"
      value = var.atlantis_web_interface_username
    },
    {
      name  = "ATLANTIS_WEB_PASSWORD"
      value = var.atlantis_web_interface_password
    },
    {
      name  = "ATLANTIS_WRITE_GIT_CREDS"
      value = "true"
    }
  ]

  # logging
  #firelens_configuration = {
  #type = "fluentbit"
  #}

  #memory_reservation = 50
}

resource "aws_ecs_service" "ecs_service" {
  depends_on = [module.alb]

  name        = "${var.name}-service"
  cluster     = var.cluster_id
  launch_type = "FARGATE"
  #deployment_maximum_percent         = "100"
  #deployment_minimum_healthy_percent = "100"
  desired_count = "1"

  network_configuration {
    subnets = var.public_subnet_ids
    #security_groups = var.security_group_ids
    security_groups = module.security_groups.atlantis_security_group_ids
  }

  task_definition = aws_ecs_task_definition.ecs_task_definition.arn

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = var.name
    container_port   = var.atlantis_port
  }

  # force redeployment on every apply
  force_new_deployment = true
  triggers = {
    redeployment = timestamp()
  }
}

module "security_groups" {
  source = "git::git@bitbucket.org:metamorphant/aws-atlantis-security-groups.git//."

  atlantis_port = var.atlantis_port
  vpc_id        = data.aws_vpc.vpc.id
  tags          = var.tags
}

module "alb" {
  depends_on = [module.security_groups]

  source = "git::git@bitbucket.org:metamorphant/aws-elb-alb.git//."

  name                                 = var.name
  vpc_id                               = var.vpc_id
  security_group_ids                   = module.security_groups.alb_security_group_ids
  cidr_blocks_with_unrestricted_access = local.bitbucket_ipv4_cidrs
  certificate_arn                      = var.certificate_arn
  public_subnet_ids                    = var.public_subnet_ids
  backend_port                         = var.atlantis_port
  tags                                 = var.tags
}
