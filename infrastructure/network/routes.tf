resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-rt-pub-01"
    },
    local.tags
  )
}

resource "aws_route_table_association" "pub" {
  count          = var.availability_zones
  subnet_id      = element(aws_subnet.pub.*.id, count.index)
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table" "pri" {
  count  = var.availability_zones
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  tags = merge(
    {
      "Name" = format("%s-rt-pri-0%s", var.resource_prefix, count.index + 1)
    },
    local.tags
  )
}

resource "aws_route_table_association" "pri" {
  count          = var.availability_zones
  subnet_id      = element(aws_subnet.pri.*.id, count.index)
  route_table_id = element(aws_route_table.pri.*.id, count.index)
}