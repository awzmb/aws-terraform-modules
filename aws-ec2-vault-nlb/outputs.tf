output "lb_arn" {
  description = "The ID and ARN of the load balancer."
  value       = aws_lb.nlb.arn
}

output "https_listener_arn" {
  description = "The ARNs of the HTTPS load balancer listener."
  value       = aws_lb_listener.https_listener.arn
}

output "target_group_arn" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.target_https_passthrough.arn
}

output "lb_dns_name" {
  description = "What DNS name the LB gets"
  value       = aws_lb.nlb.dns_name
}
