variable "name" {
  description = "Name prefix used for cluster and additional resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to run the service on."
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the LB."
  type        = list(string)
}

variable "atlantis_port" {
  description = "Port of the container to forward."
  type        = number
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
