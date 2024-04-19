variable "zone_id" {
  description = "The ID of the hosted zone to contain this record"
  type        = string
}

variable "record_name" {
  description = "The name of the record"
  type        = string
}

variable "record_type" {
  description = "The record type. Valid values are A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT."
  type        = string
}

variable "records" {
  description = "A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add \"\" inside the Terraform configuration string (e.g., \"first255characters\"\"morecharacters\")."
  type        = list(string)
}

variable "ttl" {
  description = "(Required for non-alias records) The TTL of the record."
  default     = 300
  type        = number
}
