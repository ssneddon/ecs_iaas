variable "environment" {
  description = "A name to describe the environment we're creating."
}

variable "project" {
  description = "The project name"
}

variable "application" {
  description = "The application name"
}

variable "vpc_cidr" {
  description = "The IP range to attribute to the virtual network."
}
variable "public_subnet_cidrs" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type = list
}
variable "private_subnet_cidrs" {
  description = "The IP ranges to use for the private subnets in your VPC."
  type = list
}
variable "availability_zones" {
  description = "The AWS availability zones to create subnets in."
  type = list
}


locals {
  project_tags = {
    Automation  = "terraform"
    Project     = var.project
    Application = var.application
    Environment = var.environment
    Name        = "${var.project}-${var.environment}_infra"
  }
}
