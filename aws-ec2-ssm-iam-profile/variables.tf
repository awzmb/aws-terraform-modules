variable "name" {
  description = "The name of the resulting iam profile name."
  type        = string
}

variable "role_name" {
  description = "The name of the resulting role included by the iam profile."
  type        = string
}

variable "key_arn" {
  description = "ARN of the key to encrypt communication to SSM with."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
