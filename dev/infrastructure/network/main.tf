module "vpc" {
  source       = "./vpc"

  project      = var.project
  cidr         = var.vpc_cidr
  environment  = var.environment
  project_tags = var.project_tags
}

module "private_subnet" {
  source             = "./subnets"

  subnet_name        = "${var.project}_${var.environment}_private_subnet"
  environment        = var.environment
  vpc_id             = module.vpc.id
  cidrs              = var.private_subnet_cidrs
  availability_zones = var.availability_zones
  project_tags       = var.project_tags
  project            = var.project
  tier               = "private"
}

module "public_subnet" {
  source             = "./subnets"

  subnet_name        = "${var.project}_${var.environment}_public_subnet"
  environment        = var.environment
  vpc_id             = module.vpc.id
  cidrs              = var.public_subnet_cidrs
  availability_zones = var.availability_zones
  project_tags       = var.project_tags
  project            = var.project
  tier               = "public"

}

module "nat" {
  source       = "./nat_gateway"

  environment  = var.environment
  subnet_ids   = module.public_subnet.ids
  subnet_count = length(var.public_subnet_cidrs)
  project_tags = var.project_tags
}

resource "aws_route" "public_igw_route" {
  count                  = length(var.public_subnet_cidrs)
  route_table_id         = element(module.public_subnet.route_table_ids, count.index)
  gateway_id             = module.vpc.igw
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_route" "private_nat_route" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = element(module.private_subnet.route_table_ids, count.index)
  nat_gateway_id         = element(module.nat.ids, count.index)
  destination_cidr_block = var.destination_cidr_block
}

# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding.
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished.
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "dummy_dependency" {
  depends_on = [module.nat]
}