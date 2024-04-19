output "arn" {
  description = "ARN that identifies the cluster."
  value       = aws_ecs_cluster.ecs_fargate_cluster.arn
}

output "id" {
  description = "ID that identifies the cluster."
  value       = aws_ecs_cluster.ecs_fargate_cluster.id
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the task execution role."
  value       = aws_iam_role.ecs_task_execution.arn
}
