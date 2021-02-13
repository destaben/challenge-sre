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

variable "cluster_id" {
  type        = string
  description = "Cluster Id"
}

variable "instance_type_workers" {
  type        = string
  description = "K8s Workers Instance Types"
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

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "pri_subnet_ids" {
  type        = list(string)
  description = "App Subnets Ids"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr"
}

variable "alerting_sms_number" {
  type        = string
  description = "SMS for alerting"
}

variable "location" {
  type        = string
  description = "Region where resources are deployed"
}