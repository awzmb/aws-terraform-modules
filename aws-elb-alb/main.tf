terraform {
  required_providers {
    aws = "> 3.0"
  }
}

locals {
  whitelist_unauthenticated_cidr_block_chunks = chunklist(
    sort(compact(concat(var.cidr_blocks_with_unrestricted_access))),
    5
  )
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = var.name

  vpc_id          = var.vpc_id
  subnets         = var.public_subnet_ids
  security_groups = var.security_group_ids

  enable_cross_zone_load_balancing = false

  #access_logs = {
  #enabled = var.alb_logging_enabled
  #bucket  = var.alb_log_bucket_name
  #prefix  = var.alb_log_location_prefix
  #}

  # "dualstack" for ipv4/6 or "ipv4"
  ip_address_type = "dualstack"

  # disable old TLS versions for security reasons
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
  listener_ssl_policy_default = "ELBSecurityPolicy-TLS-1-2-2017-01"

  https_listeners = [
    {
      target_group_index = 0
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      action_type        = "forward"
    },
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = 443
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  target_groups = [
    {
      name                 = var.name
      backend_protocol     = "HTTP"
      backend_port         = var.backend_port
      target_type          = var.target_type
      deregistration_delay = 10
      health_check = {
        path = "/healthz"
      }
    },
  ]

  tags = var.tags
}

# forward action for certain cidr blocks to bypass authentication (eg. bitbucket webhooks)
resource "aws_lb_listener_rule" "unauthenticated_access_for_cidr_blocks" {
  count = length(local.whitelist_unauthenticated_cidr_block_chunks)

  listener_arn = module.alb.https_listener_arns[0]
  #priority     = "100"

  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[0]
  }

  condition {
    source_ip {
      values = local.whitelist_unauthenticated_cidr_block_chunks[count.index]
    }
  }
}
