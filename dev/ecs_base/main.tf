module "alb" {
  source                 = "./alb"

  project                = data.aws_vpc.vpc.tags.Project
  vpc_id                 = data.aws_vpc.vpc.id
  environment            = data.aws_vpc.vpc.tags.Environment
  public_subnet_ids      = data.aws_subnet_ids.public_subnet_ids.ids
  project_tags           = local.project_tags
  alb_sg_id              = data.aws_security_group.alb_sg.id
  acm_cert_arn           = data.aws_acm_certificate.acm_cert.arn
}

module "efs" {
  source             = "./efs"

  private_subnet_ids = data.aws_subnet_ids.private_subnet_ids.ids
  project_tags       = local.project_tags
  efs_sg_id          = data.aws_security_group.efs_sg.id
}

module "ecs_instances" {
  source = "./ecs_instances"

  environment             = data.aws_vpc.vpc.tags.Environment
  cluster                 = var.cluster
  private_subnet_ids      = data.aws_subnet_ids.private_subnet_ids.ids
  /*aws_ami defaults to custom ami defined in ecs instance module*/
  aws_ami                 = var.ecs_aws_ami
  instance_type           = var.instance_type
  max_size                = var.max_size
  min_size                = var.min_size
  desired_capacity        = var.desired_capacity
  vpc_id                  = data.aws_vpc.vpc.id
  iam_instance_profile_name = data.aws_iam_instance_profile.instance_profile.name
//  depends_id              = var.depends_id
  custom_userdata         = var.custom_userdata
  cloudwatch_prefix       = var.cloudwatch_prefix
  project_tags            = local.project_tags
  instance_sg_id          = data.aws_security_group.instance_sg.id
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster
  tags = local.project_tags
}

resource "local_file" "cluster_name" {
  content = var.cluster
  filename = "${path.root}/cluster.name"
}

resource "local_file" "access_point_id" {
  content = module.efs.access_point_id
  filename = "${path.root}/access_point.id"
}

resource "local_file" "efs_id" {
  content = module.efs.file_system_id
  filename = "${path.root}/efs.id"
}

resource "local_file" "domain_name" {
  filename = "${path.root}/domain.name"
  content = var.domain_name
}