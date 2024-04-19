variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "redirect_bucket_name" {
  description = "The name of the bucket to which http requests will be redirected."
  type        = string
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}