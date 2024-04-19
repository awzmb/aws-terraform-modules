output "fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = aws_route53_record.record.fqdn
}