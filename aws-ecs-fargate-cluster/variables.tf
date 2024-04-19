variable "name" {
  description = "Name prefix used for cluster and additional resources."
  type        = string
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
