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

variable "alias_name" {
  description = "DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone."
  type        = string
}

variable "alias_zone_id" {
  description = "Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone."
  type        = string
}

variable "evaluate_target_health" {
  description = "Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone."
  default     = false
  type        = bool
}


