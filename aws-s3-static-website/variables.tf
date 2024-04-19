variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "bucket_users" {
  description = "The user which is allowed to put objects in S3 bucket."
  type        = list(string)
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
