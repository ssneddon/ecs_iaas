data "local_file" "vpc" {
  filename = "../infrastructure/vpc.id"
}

data "local_file" "project_tags" {
  filename = "../infrastructure/project.tags"
}

data "aws_vpc" "vpc" {
  id = data.local_file.vpc.content
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Tier"
    values = ["private"]
  }
}

data "aws_subnet"  "private" {
  for_each = data.aws_subnet_ids.private_subnet_ids.ids
  id       = each.value
}

output "private_subnet_cidrs" {
  value = [ for s in data.aws_subnet.private: s.cidr_block]
}

output "subnet_azs" {
  value = [ for s in data.aws_subnet.private: s.availability_zone]
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Tier"
    values = ["public"]
  }
}

data "aws_subnet"  "public" {
  for_each = data.aws_subnet_ids.public_subnet_ids.ids
  id       = each.value
}

output "public_subnet_cidrs" {
  value = [ for s in data.aws_subnet.public: s.cidr_block]
}

data "aws_security_group" "alb_sg" {
  name = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_alb_sg"
}

data "aws_security_group" "tasks_sg" {
  name = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_ecs_tasks_sg"
}

data "aws_security_group" "efs_sg" {
  name = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_efs_sg"
}

data "aws_security_group" "instance_sg" {
  name = "${data.aws_vpc.vpc.tags.Project}_${data.aws_vpc.vpc.tags.Environment}_ecs_instances_sg"
}

data "aws_iam_instance_profile" "instance_profile" {
  name = "ecs_instance_profile"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
}