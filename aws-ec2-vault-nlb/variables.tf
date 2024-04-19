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

variable "public_subnet_ids" {
  description = "Public subnet IDs to connect the ALB to."
  type        = list(string)
}

variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "enable_health_check" {
  description = "Whether to enable HealthChecks on the targets, defaults to true"
  default = true
  type = bool
}

variable "health_check_path" {
  description = "Where the HealthChecks should check, defaults to '/'"
  type = string
  default = "/"
}
