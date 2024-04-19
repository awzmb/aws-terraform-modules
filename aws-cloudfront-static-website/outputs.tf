output "domain_name" {
  description = "Domain name corresponding to the distribution."
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "hosted_zone_id" {
  description = "CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}
