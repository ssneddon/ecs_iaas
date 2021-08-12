resource "aws_ecs_task_definition" "service" {
  family                   = "${data.aws_vpc.vpc.tags.Project}-${data.aws_vpc.vpc.tags.Environment}"
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.task_execution_role.arn
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["EC2"]
  container_definitions    = data.template_file.taskDef.rendered
  task_role_arn            = data.aws_iam_role.task_role.arn
  volume {
    name = "jenkins-home"

    efs_volume_configuration {
      file_system_id     = data.local_file.efs_id.content
      transit_encryption = "ENABLED"
      root_directory = "/var/jenkins_home"

      authorization_config {
        access_point_id = data.local_file.access_point_id.content
        iam             = "ENABLED"
      }
    }

  }

  volume {
    name = "docker_data"
    host_path = "/dev/sdf"

  }

  tags = local.project_tags
}