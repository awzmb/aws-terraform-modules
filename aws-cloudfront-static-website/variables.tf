variable "s3_domain_name" {
  description = "DNS domain name of either the S3 bucket, or web site of your custom origin."
  type        = string
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of the AWS Certificate Manager certificate that you wish to use with this distribution."
  type        = string
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
