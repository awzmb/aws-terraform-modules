variable "atlantis_port" {
  description = "Atlantis port to enable incoming traffic from Bitbucket Cloud to."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to assign the security groups with (use the same VPC as the Atlantis container is associated with)."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
