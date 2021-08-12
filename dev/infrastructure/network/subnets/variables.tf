variable "subnet_name" {
  description = "Name of the subnet, actual name will be, for example: name_eu-west-1a"
}

variable "environment" {
  description = "The name of the environment"
}

variable "cidrs" {
  type        = list
  description = "List of cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "availability_zones" {
  type        = list
  description = "List of availability zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "vpc_id" {
  description = "VPC id to place subnet into"
}

variable "project_tags" {
  description = "project tags"
}

variable "project" {
  description = "project name"
}

variable "tier" {
  description = "the tier of the subnet"
}
