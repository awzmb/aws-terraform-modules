variable "domain_name" {
  description = "Domain name of the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate."
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route53 zone id for DNS validation records"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the key and other resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
