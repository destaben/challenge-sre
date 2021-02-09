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

variable "cidr" {
  type        = string
  description = "VPC cidr"
}

variable "k8s_cluster_ids" {
  type        = list(string)
  description = "K8s Cluster Ids"
}

variable "availability_zones" {
  type        = number
  description = "Number of availability zones to use"
}

variable "domain_name" {
  type        = string
  description = "Route 53 name"
}
