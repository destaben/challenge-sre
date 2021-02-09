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

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "pub_subnet_id" {
  type        = string
  description = "Subnet Id"
}

variable "ami_id" {
  type        = string
  description = "Ami Id"
}

variable "route53_zone_id" {
  type = string
}

variable "key_name" {
  type        = string
  description = "SSH Key name"
}
