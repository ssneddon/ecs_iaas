resource "aws_efs_file_system" "efs_ecs" {
  tags = var.project_tags
}

resource "aws_efs_mount_target" "mount" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.efs_ecs.id
  subnet_id       =  element(var.private_subnet_ids, count.index)
  security_groups = [var.efs_sg_id]
}

resource "aws_efs_access_point" "access_point" {
  file_system_id = aws_efs_file_system.efs_ecs.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "755"
    }
    path = "/jenkins-home"
  }

  tags = var.project_tags
}