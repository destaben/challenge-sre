resource "aws_route53_zone" "private" {
  name = "${var.domain_name}."
  vpc {
    vpc_id = aws_vpc.vpc.id
  }
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-route53-pri-01"
    },
    local.tags,
  )
}
