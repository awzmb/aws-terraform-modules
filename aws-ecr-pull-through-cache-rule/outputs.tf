output "registry_id" {
  description = "The registry ID where the repository was created."
  value       = aws_ecr_pull_through_cache_rule.rule.registry_id
}
