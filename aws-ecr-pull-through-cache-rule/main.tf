
terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_ecr_pull_through_cache_rule" "rule" {
  ecr_repository_prefix = var.ecr_repository_prefix
  upstream_registry_url = var.upstream_registry_url
}
