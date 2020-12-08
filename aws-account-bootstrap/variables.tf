variable "tags" {
  description = "Tags of the DynamoDB Table for locking Terraform state."
  default = {
    owner     = "owner"
    managedby = "terraform"
  }
  type = map(string)
}

variable "region" {
  description = "AWS region."
  type        = string
}

variable "account_alias" {
  description = "The desired AWS account alias."
  type        = string
}

variable "bucket_purpose" {
  description = "Name to identify the bucket's purpose"
  default     = "tf-state"
  type        = string
}
