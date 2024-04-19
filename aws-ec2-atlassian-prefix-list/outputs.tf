output "ipv4_prefix_list_arn" {
  description = "ID of the ipv4 prefix list."
  value       = aws_ec2_managed_prefix_list.ipv4_prefix_list.arn
}

output "ipv4_prefix_list_id" {
  description = "ARN of the ipv4 prefix list."
  value       = aws_ec2_managed_prefix_list.ipv4_prefix_list.id
}

output "ipv6_prefix_list_arn" {
  description = "ID of the ipv6 prefix list."
  value       = aws_ec2_managed_prefix_list.ipv6_prefix_list.arn
}

output "ipv6_prefix_list_id" {
  description = "ARN of the ipv6 prefix list."
  value       = aws_ec2_managed_prefix_list.ipv6_prefix_list.id
}
