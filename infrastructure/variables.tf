# AWS
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "location" {
  type        = string
  description = "Region where resources are deployed"
}

# General
variable "environment" {
  type        = string
  description = "Environment code prefix"
}

variable "project" {
  type        = string
  description = "Tag identifying the project"
}

variable "resource_prefix" {
  type        = string
  description = "Project code Prefix"
}

# Network
variable "availability_zones" {
  type        = number
  default     = 2
  description = "Number of availability zones to use"
}

variable "cidr" {
  type        = string
  description = "VPC cidr"
}

# Kubernetes
variable "instance_type_workers" {
  type        = string
  default     = "t3.medium"
  description = "Instance type node workers"
}

variable "max_workers" {
  type        = number
  default     = 3
  description = "Maximum number of worker nodes"
}

variable "min_workers" {
  type        = number
  default     = 1
  description = "Minimum number of worker nodes"
}

variable "des_workers" {
  type        = number
  default     = 2
  description = "Desired number of worker nodes"
}

#Pipeline
variable "github_token" {
  type        = string
  description = "Github token"
}