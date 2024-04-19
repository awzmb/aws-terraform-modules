terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.ttl
  records = var.records
}
