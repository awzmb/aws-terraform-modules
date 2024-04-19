output "alb_security_group_ids" {
  value = [aws_security_group.atlassian_alb_sg.id]
}

output "alb_security_group_arns" {
  value = [aws_security_group.atlassian_alb_sg.arn]
}

output "atlantis_security_group_ids" {
  value = [aws_security_group.atlantis_sg.id]
}

output "atlantis_security_group_arns" {
  value = [aws_security_group.atlantis_sg.arn]
}
