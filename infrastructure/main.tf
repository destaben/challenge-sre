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

provider "template" {
  version = "~> 2.2.0"
}

provider "helm" {
  version = "~> 2.0.2"
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "null" {
  version = "~> 3.0.0"
}

terraform {
  required_version = "~> 0.13"
}