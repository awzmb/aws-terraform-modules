variable "name" {
  description = "Name (prefix) for ALB resources to be created."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to connect the ALB to."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs for the ALB."
  type        = list(string)
}

variable "cidr_blocks_with_unrestricted_access" {
  description = "List of CIDR blocks with unrestricted access (g.e. private subnets or external ip ranges)."
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of certificate issued by AWS ACM (use the certificate for the domain you are using)."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs to connect the ALB to."
  type        = list(string)
}

variable "backend_port" {
  description = "Backend port to forward traffic to (use the application or container port)."
  type        = string
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with the resulting target group. See docs for supported values. defaults to ip. Use instance if using with EC3 instances."
  default     = "ip"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
