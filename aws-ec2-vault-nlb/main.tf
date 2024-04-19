terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_lb" "nlb" {
  #checkov:skip=CKV2_AWS_20:We're redirecting to TCP (as opposed to HTTPS), because of TLS-Passthrough
  #checkov:skip=CKV_AWS_150:We might still need to delete this, it's a dev prototype
  ##checkov:skip=CKV_AWS_91:Access Logs we do once we know what we're doing

  name = var.name

  internal = false
  load_balancer_type = "network"

  subnets         = var.public_subnet_ids
  security_groups = var.security_group_ids

  enable_cross_zone_load_balancing = true

  #access_logs = {
  #enabled = var.alb_logging_enabled
  #bucket  = var.alb_log_bucket_name
  #prefix  = var.alb_log_location_prefix
  #}

  # "dualstack" for ipv4/6 or "ipv4"
  ip_address_type = "dualstack"

  tags = var.tags
}

resource "aws_lb_listener" "http_listener" {
  #checkov:skip=CKV_AWS_2:This is an NLB
  #checkov:skip=CKV_AWS_103:We do TLS-Passthrough

  load_balancer_arn = aws_lb.nlb.arn
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.target_http.arn
      }
    }
  }

  port = 80
  protocol = "HTTP"

  tags = var.tags
}

resource "aws_lb_listener" "https_listener" {
  #checkov:skip=CKV_AWS_2:This is an NLB
  #checkov:skip=CKV_AWS_103:We do TLS-Passthrough

  load_balancer_arn = aws_lb.nlb.arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.target_https_passthrough.arn
      }
    }
  }

  tags = var.tags
}

resource "aws_lb_target_group" "target_https_passthrough" {
  name = "${var.name}-https-tg"
  port = 443
  protocol = "HTTPS"
  vpc_id = var.vpc_id

  health_check {
    enabled = var.enable_health_check
    path = var.health_check_path
  }

  tags = var.tags
}

resource "aws_lb_target_group" "target_http" {
  name = "${var.name}-http-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = var.enable_health_check
  }

  tags = var.tags
}
