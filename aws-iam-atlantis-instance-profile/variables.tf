variable "name" {
  description = "The name of the resulting iam profile name."
  type        = string
}

variable "key_arn" {
  description = "ARN of the key to encrypt communication to SSM with."
  type        = string
}

variable "tags" {
  description = "Tags for the role"
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "key_sops_arn" {
  description = "ARN of the key used for SOPS"
  type        = string
}
