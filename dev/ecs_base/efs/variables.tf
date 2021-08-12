variable "private_subnet_ids" {
  description = "The IDs to use for the private subnets in your VPC.."
  type = list
}

variable "project_tags" {
  description = "the project tags"
}

variable "efs_sg_id" {
  description = "the efs security group id"
}