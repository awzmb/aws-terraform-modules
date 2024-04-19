variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "domain_name" {
  description = "Domain name for the hosted zone."
  type        = string
}

