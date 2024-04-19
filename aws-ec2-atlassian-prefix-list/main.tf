terraform {
  required_providers {
    aws = "> 3.0"
    http = {
      source = "hashicorp/http"
    }
  }
}

data "http" "atlassian_ips" {
  url = "https://ip-ranges.atlassian.com/"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  # get atlassian global and eu cidr blocks
  atlassian_eu_items   = [for c in jsondecode(data.http.atlassian_ips.response_body).items : c if length(regexall("eu-.*|global", c.region[0])) > 0]
  atlassian_ipv4_cidrs = [for c in local.atlassian_eu_items : c.cidr if length(regexall(":", c.cidr)) == 0]
  atlassian_ipv6_cidrs = [for c in local.atlassian_eu_items : c.cidr if length(regexall(":", c.cidr)) > 0]
}

resource "aws_ec2_managed_prefix_list" "ipv4_prefix_list" {
  name           = "atlassian-ip-ranges-prefix-list-ipv4"
  address_family = "IPv4"
  max_entries    = 100

  dynamic "entry" {
    for_each = local.atlassian_ipv4_cidrs
    content {
      cidr = entry.value
    }
  }

  tags = var.tags
}

resource "aws_ec2_managed_prefix_list" "ipv6_prefix_list" {
  name           = "atlassian-ip-ranges-prefix-list-ipv6"
  address_family = "IPv6"
  max_entries    = 100

  dynamic "entry" {
    for_each = local.atlassian_ipv6_cidrs
    content {
      cidr = entry.value
    }
  }

  tags = var.tags
}
