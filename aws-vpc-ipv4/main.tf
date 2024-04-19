terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  name   = var.name
  region = var.region
  azs    = slice(data.aws_availability_zones.available.names, 0, 3)
  tags   = var.tags
}

module "vpc-central" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = var.cidr

  azs = local.azs

  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]

  manage_default_security_group = true
  default_security_group_name   = "${local.name}-sg"

  create_database_subnet_group = false

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_dns_hostnames = true
  enable_dns_support   = true

  # create internet gateway
  create_igw = true

  # enable a nat gateways for private subnets
  # so machines are able to connect to other aws
  # services without having to use vpc private
  # endpoints (which are rather expensive)
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = false

  private_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    }
  ]

  private_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    }
  ]

  default_security_group_ingress = [
    {
      description      = "Allow incoming TLS connections"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    },
    {
      description      = "Allow HTTP connections"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    },
    {
      description      = "Allow incoming SSH connections"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    },
    {
      description      = "Allow incoming DNS connections"
      from_port        = 53
      to_port          = 53
      protocol         = "tcp"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  default_security_group_egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }
  ]

  tags = local.tags
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc-central.vpc_id
}

module "vpc_endpoints" {
  count = var.enable_ecr_vpc_endpoints ? 1 : 0

  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc-central.vpc_id
  security_group_ids = [data.aws_security_group.default.id]

  endpoints = {
    s3 = {
      service = "s3"
    },
    ecr_api = {
      service = "ecr.api"
    },
    ecr_dkr = {
      service = "ecr.dkr"
    }
  }

  tags = local.tags
}

#output "private_subnets" {
#value = [module.vpc-central.private_subnets]
#}
