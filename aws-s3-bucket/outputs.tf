output "id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.bucket.id
}

output "arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.bucket.arn
}

output "name" {
  description = "The Name of the bucket. Will be of format bucketprefix-bucketname."
  value       = "${local.bucket_prefix}${var.bucket_name}"
}

output "bucket_domain_name" {
  description = "The bucket domain name."
  value       = aws_s3_bucket.bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name."
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}

