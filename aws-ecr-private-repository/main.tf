terraform {
  required_providers {
    aws = "> 3.0"
  }
}

resource "aws_ecr_repository" "repository" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
