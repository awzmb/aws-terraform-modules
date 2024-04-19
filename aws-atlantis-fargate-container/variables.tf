variable "name" {
  description = "Name prefix used for cluster and additional resources."
  type        = string
}

variable "container_cpu" {
  description = "Number of cpu units used by the task."
  default     = 2
  type        = number
}

variable "container_memory" {
  description = "Amount (in MiB) of memory used by the task."
  type        = number
}

variable "image" {
  description = "URL pointing to the image (Docker registry or similar)."
  type        = string
}

variable "cluster_id" {
  description = "ID of the cluster to deploy the service on."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to run the service on."
  type        = string
}

#variable "security_group_ids" {
#description = "IDs of the security groups for the service."
#type        = list(string)
#}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the task execution role."
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

variable "private_subnet_ids" {
  description = "Private subnet IDs for the LB."
  type        = list(string)
}

variable "atlantis_port" {
  description = "Port of the container to forward."
  type        = number
}

variable "atlantis_url" {
  description = "FQDN the Atlantis server is reachable with."
  type        = string
}

#variable "atlantis_bitbucket_user" {
#description = "Username to access the Bitbucket server with."
#type        = string
#}

variable "atlantis_bitbucket_token" {
  description = "Bitbucket app password of API user."
  sensitive   = true
  type        = string
}

variable "atlantis_bitbucket_base_url" {
  description = "Base URL of the Bitbucket server to pull changes from."
  type        = string
}

variable "atlantis_web_interface_username" {
  description = "BasicAuth username to access the Atlantis web UI."
  sensitive   = true
  type        = string
}

variable "atlantis_web_interface_password" {
  description = "BasicAuth password to access the Atlantis web UI."
  sensitive   = true
  type        = string
}

variable "atlantis_repo_allowlist" {
  description = "Atlantis requires you to specify a allowlist of repositories it will accept webhooks from via the --repo-allowlist flag. For example. Specific repositories: --repo-allowlist=github.com/runatlantis/atlantis,github.com/runatlantis/atlantis-tests. Every repository in your GitHub Enterprise install: --repo-allowlist=github.yourcompany.com/*"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the cluster and additional resources."
  default = {
    managedby = "terraform"
  }
  type = map(string)
}
