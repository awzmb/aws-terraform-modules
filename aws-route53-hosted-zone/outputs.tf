output "zone_arn" {
  description = "ARN of the hosted zone."
  value       = aws_route53_zone.zone.arn
}

output "zone_id" {
  description = "ID of the hosted zone."
  value       = aws_route53_zone.zone.id
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set."
  value       = aws_route53_zone.zone.name_servers
}

output "certificate_id" {
  description = "ID of the certificate."
  value       = aws_acm_certificate.certificate.id
}

output "certificate_arn" {
  description = "ARN of the certificate."
  value       = aws_acm_certificate.certificate.id
}

output "domain_name" {
  description = "Resulting domain name."
  value       = aws_acm_certificate.certificate.domain_name
}

