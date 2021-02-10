data "aws_availability_zones" "aws_azs" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-vpc-01"
    },
    local.tags,
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-ig-01"
    },
    local.tags,
  )
}

resource "aws_vpc_dhcp_options" "dhcp_opts" {
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-do-01"
    },
    local.tags,
  )
}

resource "aws_vpc_dhcp_options_association" "dhcp_opts" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_opts.id
}

resource "aws_subnet" "pub" {
  count                   = var.availability_zones
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 0 + count.index)
  availability_zone       = element(data.aws_availability_zones.aws_azs.names, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    {
      "Name"            = format("%s-sub-pub-0%s", var.resource_prefix, count.index + 1)
      "SubnetType"      = "Public"
      "kubernetes.io/role/elb" = 1
    },
    local.tags
  )
}

resource "aws_subnet" "pri" {
  count                   = var.availability_zones
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, var.availability_zones + count.index)
  availability_zone       = element(data.aws_availability_zones.aws_azs.names, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name"                     = format("%s-sub-pri-0%s", var.resource_prefix, count.index + 1)
      "SubnetType"               = "Private"
      "kubernetes.io/role/internal-elb" = 1
    },
    local.tags,
  )
}