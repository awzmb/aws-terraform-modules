variable "name" {
  description = "Name of the repository."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the repository."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
