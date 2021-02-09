resource "aws_eip" "eip_nat" {
  count = var.availability_zones
  vpc   = true
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-ip-nat-0${count.index + 1}"
    },
    local.tags
  )
}

resource "aws_nat_gateway" "nat" {
  count         = var.availability_zones
  allocation_id = element(aws_eip.eip_nat.*.id, count.index)
  subnet_id     = element(aws_subnet.pub.*.id, count.index)
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-nat-0${count.index + 1}"
    },
    local.tags
  )
}
