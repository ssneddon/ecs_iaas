module "network" {
  source               = "./network"

  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
  project              = var.project
  project_tags         = local.project_tags
}

module "cloudtrail" {
  source              = "./cloudtrail"

  project             = var.project
  environment         = var.environment
  project_tags        = local.project_tags
  cloudtrail_role_arn = data.aws_iam_role.cloudtrail_role.arn
}

resource "local_file" "vpc" {
  content = module.network.vpc_id
  filename = "${path.root}/vpc.id"
}

resource "local_file" "project_tags" {
  content = jsonencode(local.project_tags)
  filename = "${path.root}/project.tags"
}
