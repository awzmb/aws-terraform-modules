output "certificate_id" {
  description = "ID of the certificate."
  value       = aws_acm_certificate.certificate.id
}

output "certificate_arn" {
  description = "ARN of the certificate."
  value       = aws_acm_certificate.certificate.arn
}