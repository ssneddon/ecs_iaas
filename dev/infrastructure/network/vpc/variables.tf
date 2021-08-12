variable "cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "environment" {
  description = "The name of the environment"
}

variable "project" {
  description = "The name for tagging resources"
}

variable "project_tags" {
  description = "project tags"
}