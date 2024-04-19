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
  bitbucket_ipv4_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) == 0]
  bitbucket_ipv6_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) > 0]
}

# fetch data from vpc per id
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

module "security_groups" {
  source = "git::git@bitbucket.org:metamorphant/aws-atlantis-security-groups.git//.?ref=1.0.0"

  atlantis_port = var.atlantis_port
  vpc_id        = data.aws_vpc.vpc.id
  tags          = var.tags
}

module "alb" {
  depends_on = [module.security_groups]

  source = "git::git@bitbucket.org:metamorphant/aws-elb-alb.git//.?ref=1.2.0"

  name                                 = var.name
  vpc_id                               = var.vpc_id
  security_group_ids                   = module.security_groups.alb_security_group_ids
  cidr_blocks_with_unrestricted_access = local.bitbucket_ipv4_cidrs
  certificate_arn                      = var.certificate_arn
  public_subnet_ids                    = var.public_subnet_ids
  backend_port                         = var.atlantis_port
  tags                                 = var.tags
}
