variable "subnet_ids" {
  type        = list
  description = "List of subnets in which to place the NAT Gateway"
}

variable "subnet_count" {
  description = "Size of the subnet_ids. This needs to be provided because: value of 'count' cannot be computed"
}

variable "environment" {
  description = "The name of the environment"
}

variable "project_tags" {
  description = "project tags"
}
