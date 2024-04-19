provider "aws" {
  region = "us-west-2"
}

provider "github" {
  token = var.github_token
}
