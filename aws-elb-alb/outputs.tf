output "lb_arn" {
  description = "The ID and ARN of the load balancer."
  value       = module.alb.lb_arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners."
  value       = module.alb.https_listener_arns
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb.target_group_arns
}
