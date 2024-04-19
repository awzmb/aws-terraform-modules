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

variable "vpc_id" {
  description = "ID of the VPC to run the service on."
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance (defaults to t2.nano)."
  default     = "t2.nano"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Associate a public address to the instance (defaults to false)."
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

variable "atlantis_port" {
  description = "Port of the container to forward."
  type        = number
}
