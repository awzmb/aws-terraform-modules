output "arn" {
  description = "The name of the key."
  value       = aws_kms_key.cmk.arn
}

output "key_id" {
  description = "The id of the key."
  value       = aws_kms_key.cmk.arn
}
