terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_route53_zone" "zone" {
  name = var.domain_name

  tags = var.tags
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = join(".", ["*", var.domain_name])
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# TODO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
# wait for certificate validation after creating the zone (and cert)
resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}
