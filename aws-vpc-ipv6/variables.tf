variable "name" {
  description = "Name of the vpc."
  type        = string
}

variable "region" {
  description = "Region to create the vpc in."
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
