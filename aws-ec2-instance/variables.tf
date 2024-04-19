variable "name" {
  description = "The name of the instance."
  type        = string
}

variable "iam_profile_name" {
  description = "The ARN of the IAM instance profile to be assigned."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key to use for inbound connections."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to pair the instance with."
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance (defaults to t2.nano)."
  default     = "t2.nano"
  type        = string
}

variable "associate_public_ipv4_address" {
  description = "Associate a public address to the instance (defaults to false). Use this only in ipv4 subnets, else the deployment will fail."
  default     = false
  type        = bool
}

variable "root_volume_size" {
  description = "(Optional) Size of the volume in gibibytes (GiB)."
  default     = 20
  type        = number
}

variable "tags" {
  description = "Tags for the policies and roles."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}

variable "cloudinit_config" {
  description = "Extra cloudinit config to be passed to the instance"
  type        = string
  default     = "echo \\$(hostname)"
}

variable "metadata_endpoint_ipv6" {
  description = "Whether the metadata endpoint should be reached via IPv6 or not: 'enabled' or 'disabled'"
  type        = string
  default     = "disabled"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone under which to place a DNS record for this instance, derived from its name."
  type        = string
  default     = ""
}
