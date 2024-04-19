output "id" {
  description = "id of the role"
  value       = aws_iam_role.assume_role.id
}

output "arn" {
  description = "arn of the role"
  value       = aws_iam_role.assume_role.arn
}

output "name" {
  description = "name of the role"
  value       = aws_iam_role.assume_role.name
}
