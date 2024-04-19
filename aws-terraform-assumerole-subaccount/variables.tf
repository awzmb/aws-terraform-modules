variable "terraform_account_id" {
  description = "id of the account terraform assumes the role from to provision the current account"
  type        = string
}

variable "tags" {
  description = "Tags for the policies and roles"
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
