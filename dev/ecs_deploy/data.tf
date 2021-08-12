data "aws_ecr_repository" "jenkins_test" {
  name = "jenkins"
}

data "local_file" "vpc" {
  filename = "../infrastructure/vpc.id"
}

data "aws_vpc" "vpc" {
  id = data.local_file.vpc.content
}

data "local_file" "cluster_name" {
  filename = "../ecs_base/cluster.name"
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = data.local_file.cluster_name.content
}

//data "aws_secretsmanager_secret" "scm_username" {
//  name = "jenkins-scm-username"
//}
//
//data "aws_secretsmanager_secret" "scm_pwd" {
//  name = "jenkins-scm-password"
//}

//data "aws_secretsmanager_secret_version" "scm_username_value" {
//  secret_id = data.aws_secretsmanager_secret.scm_username.id
//}
//
//data "aws_secretsmanager_secret_version" "scm_pwd_value" {
//  secret_id = data.aws_secretsmanager_secret.scm_pwd.id
//}

data "aws_security_group" "instance_sg" {
  name = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_ecs_instances_sg"
}

data "aws_security_group" "task_sg" {
  name = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_ecs_tasks_sg"
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Tier"
    values = ["private"]
  }
}

data "aws_lb_target_group" "target_group" {
  name = "${data.aws_vpc.vpc.tags.Project}-${data.aws_vpc.vpc.tags.Environment}-target-group"
}

data "aws_iam_role" "task_execution_role" {
  name = "ecs_execution_role"
}

data "aws_iam_role" "task_role" {
  name = "ecs_task_role"
}

data "local_file" "efs_id" {
  filename = "../ecs_base/efs.id"
}

data "local_file" "access_point_id" {
  filename = "../ecs_base/access_point.id"
}

data "aws_instance" "jenkins_instance"{

  filter {
    name = "tag:aws:autoscaling:groupName"
    values = ["${data.aws_vpc.vpc.tags.Environment}_${data.aws_ecs_cluster.cluster.cluster_name}_instance_group"]
  }
}

data "template_file" "taskDef" {
  template = file("${path.module}/templates/task-definition.json.tpl")
  vars = {
    aws_ecr_repository = data.aws_ecr_repository.jenkins_test.repository_url
    tag                = "jenkins-latest"
    project            = data.aws_vpc.vpc.tags.Project
    cluster_arn        = data.aws_ecs_cluster.cluster.arn
    instance_sg        = data.aws_security_group.instance_sg.id
    instance_subnet    = data.aws_instance.jenkins_instance.subnet_id
    scm_username       = "roelpasetes-pe"
    scm_pwd            = "tBj8ddQEyjuqA"
    environment        = data.aws_vpc.vpc.tags.Environment
    name               = data.aws_vpc.vpc.tags.Project
  }
}

data "aws_lb" "lb" {
  name = "${data.aws_vpc.vpc.tags.Project}-${data.aws_vpc.vpc.tags.Environment}-alb"
}

data "local_file" "domain_name" {
  filename = "../ecs_base/domain.name"
}

data "aws_route53_zone" "hosted_zone" {
  name = data.local_file.domain_name.content
}

data "local_file" "project_tags" {
  filename = "../infrastructure/project.tags"
}