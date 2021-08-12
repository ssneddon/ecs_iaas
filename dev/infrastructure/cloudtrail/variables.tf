variable "project" {
  description = "The name for tagging resources"
}

variable "environment" {
  description = "The name of the environment"
}

variable "project_tags" {
  description = "project tags"
}

variable "cloudtrail_role_arn" {
  description = "the role arn of cloudtrail for cloudwatch access"
}