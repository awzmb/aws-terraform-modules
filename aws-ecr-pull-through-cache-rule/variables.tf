variable "ecr_repository_prefix" {
  description = "The repository name prefix to use when caching images from the source registry."
  type        = string
}

variable "upstream_registry_url" {
  description = "The registry URL of the upstream public registry to use as the source."
  type        = string
}
