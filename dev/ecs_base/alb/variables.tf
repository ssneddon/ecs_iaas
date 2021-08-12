variable "project" {
  description = "name for tagging purposes"
}

variable "vpc_id" {
  description = "the vpc id from network module"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "environment" {
  description = "The name of the environment"
}

variable "public_subnet_ids" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type = list
}

variable "project_tags" {
  description = "project tags"
}

variable "alb_sg_id" {
  default = "the id of the alb security group"
}

variable "acm_cert_arn" {
  description = "the arn of the acm certification"
}