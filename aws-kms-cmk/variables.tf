variable "name" {
  description = "The name of the key."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
