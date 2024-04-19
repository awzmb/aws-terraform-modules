variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
