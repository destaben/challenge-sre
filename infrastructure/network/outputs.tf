output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_subnet_ids" {
  value = aws_subnet.pub.*.id
}

output "pri_subnet_ids" {
  value = aws_subnet.pri.*.id
}

output "route53_zone_id" {
  value = aws_route53_zone.private.id
}