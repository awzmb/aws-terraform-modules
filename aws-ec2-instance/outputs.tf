output "arn" {
  description = "The ARN of the instance."
  value       = aws_instance.ec2_instance.arn
}

output "public_ip" {
  description = "Public IP address assigned to the instance, if applicable."
  value       = aws_instance.ec2_instance.public_ip
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface."
  value       = aws_instance.ec2_instance.primary_network_interface_id
}

output "private_dns" {
  description = "Private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.ec2_instance.private_dns
}

output "public_dns" {
  description = "Public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.ec2_instance.public_dns
}

output "ipv6_addresses" {
  description = "IPv6 addresses of the instance"
  value = data.aws_instance.current.ipv6_addresses
}
