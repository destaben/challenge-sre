provider "aws" {
  version    = "~> 3.27.0"
  region     = var.location
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "github" {
  token   = var.github_token
  owner   = "destaben"
  version = "~> 4.4.0"
}

terraform {
  required_version = "~> 0.13"
}