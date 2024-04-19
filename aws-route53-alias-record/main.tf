terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_route53_record" "alias_record" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
