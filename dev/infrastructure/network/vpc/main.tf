resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = var.project_tags
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id


  tags = var.project_tags
}