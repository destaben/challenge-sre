variable "resource_prefix" {
  type        = string
  description = "Prefix for Resources"
}

variable "project" {
  type        = string
  description = "Tag identifying the project"
}

variable "environment" {
  type        = string
  description = "Tag identifying the environment"
}

variable "github_token" {
  type        = string
  description = "Github token"
}