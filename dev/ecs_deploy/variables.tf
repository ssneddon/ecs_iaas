variable "desired_tasks" {
  description = "the desired number of tasks to run in the service"
}

locals {
  project_tags = jsondecode(data.local_file.project_tags.content)
}