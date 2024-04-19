output "name" {
  description = "Name of the VPC."
  value       = module.vpc-central.name
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc-central.vpc_id
}

output "vpc_arn" {
  description = "ARN of the VPC."
  value       = module.vpc-central.vpc_arn
}

output "cidr" {
  description = "ipv4 cidr block."
  value       = var.cidr
}

output "azs" {
  description = "Availability zones."
  value       = module.vpc-central.azs
}

output "private_subnets" {
  description = "List of private subnets."
  value       = module.vpc-central.private_subnets
}

output "public_subnets" {
  description = "List of public subnets."
  value       = module.vpc-central.public_subnets
}

output "default_security_group_id" {
  description = "ID of default security group."
  value       = data.aws_security_group.default.id
}
