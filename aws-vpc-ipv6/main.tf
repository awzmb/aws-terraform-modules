terraform {
  required_providers {
    aws = "> 5.0"
  }
}

locals {
  name   = var.name
  region = var.region
  tags   = var.tags

  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

data "aws_availability_zones" "available" {}

module "vpc-central" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name

  # enable ipv6 to tackle increased ipv4 external address
  # prices imposed by aws
  enable_ipv6 = true

  azs = local.azs

  public_subnet_ipv6_native    = true
  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_native   = true
  private_subnet_ipv6_prefixes = [3, 4, 5]

  enable_nat_gateway = false

  create_database_subnet_group = true

  manage_default_security_group = true
  default_security_group_name   = "${local.name}-sg"

  enable_dns_hostnames = true
  enable_dns_support   = true

  propagate_public_route_tables_vgw = true
  manage_default_route_table        = false

  # create internet gateway
  create_igw = true

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
      description      = "Allow incoming ping"
      from_port        = 8
      to_port          = 0
      protocol         = "icmp"
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

