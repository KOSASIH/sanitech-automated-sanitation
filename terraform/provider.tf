provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.resource_tags
  }
}
