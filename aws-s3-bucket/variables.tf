variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "use_account_alias_prefix" {
  description = "Whether to prefix the bucket name with the AWS account alias."
  type        = string
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "enable_bucket_force_destroy" {
  type        = bool
  default     = false
  description = "If set to true, Bucket will be emptied and destroyed when terraform destroy is run."
}

variable "enable_versioning" {
  description = "Enables versioning on the bucket."
  type        = bool
  default     = true
}
