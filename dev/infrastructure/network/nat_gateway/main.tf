resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)
  count         = var.subnet_count

  tags = var.project_tags
}

resource "aws_eip" "nat" {
  vpc   = true
  count = var.subnet_count

  tags = var.project_tags
}

