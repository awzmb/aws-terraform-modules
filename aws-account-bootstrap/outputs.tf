output "statefile_bucket_name" {
  description = "The statefile bucket name"
  value       = local.statefile_bucket_name
}

output "dynamodb_table" {
  description = "The name of the dynamo db table"
  value       = aws_dynamodb_table.statefile_lock.id
}
