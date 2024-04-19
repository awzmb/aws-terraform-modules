variable "tags" {
  description = "Tags for the role"
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
