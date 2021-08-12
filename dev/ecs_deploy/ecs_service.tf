resource "aws_ecs_service" "staging" {
  name            = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_service"
  cluster         = data.aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.desired_tasks
  launch_type     = "EC2"

  network_configuration {
    security_groups  = [data.aws_security_group.task_sg.id]
    subnets          = data.aws_subnet_ids.private_subnet_ids.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.target_group.arn
    container_name   = "${data.aws_vpc.vpc.tags.Project}-container"
    container_port   = 8080
  }

  tags = local.project_tags
}