output "name" {
  description = "The name of the iam instance profile."
  value       = var.name
}

output "arn" {
  description = "The ARN of the iam instance profile."
  value       = aws_iam_instance_profile.ec2_iam_instance_profile.arn
}
