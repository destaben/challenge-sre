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

variable "ecr_name" {
  type        = string
  description = "ECR Repo name"
}

variable "location" {
  type        = string
  description = "Region where resources are deployed"
}

variable "cluster_id" {
  type        = string
  description = "Cluster Id"
}

variable "kubectl_role_arn" {
  type        = string
  description = "Kubectl role ARN"
}

variable "alerting_sms_number" {
  type        = string
  description = "SMS for alerting"
}