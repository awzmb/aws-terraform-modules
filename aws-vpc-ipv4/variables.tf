variable "name" {
  description = "Name of the vpc."
  type        = string
}

variable "region" {
  description = "Region to create the vpc in."
  type        = string
}

variable "cidr" {
  description = "Cidr block of the vpc to create."
  type        = string
}

variable "enable_ecr_vpc_endpoints" {
  description = "Enable VPC private link endpoints for ECR."
  default     = false
  type        = bool
}

variable "tags" {
  description = "A mapping of tags to assign to the vpc and resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable the NAT gateway (for outbound internet access) for private networks. This also sets or resets single_nat_gateway!"
  default     = true
  type        = bool
}
