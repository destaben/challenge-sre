module "network" {
  source             = "./network"
  resource_prefix    = var.resource_prefix
  project            = var.project
  environment        = var.environment
  cidr               = var.cidr
  availability_zones = var.availability_zones
  k8s_cluster_ids    = [local.k8s_cluster_id]
  domain_name        = local.domain_name
}

module "eks" {
  source                     = "./eks"
  resource_prefix            = var.resource_prefix
  project                    = var.project
  environment                = var.environment
  cluster_id                 = local.k8s_cluster_id
  vpc_id                     = module.network.vpc_id
  pri_subnet_ids             = module.network.pri_subnet_ids
  aws_security_group_bastion = module.bastion.aws_security_group_bastion
  vpc_cidr                   = var.cidr
  instance_type_workers      = var.instance_type_workers
  max_workers                = var.max_workers
  min_workers                = var.min_workers
  des_workers                = var.des_workers
}

data "aws_ami" "bastion" {
  most_recent = true
  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
  owners = ["099720109477"]
}


module "bastion" {
  source          = "./bastion"
  resource_prefix = var.resource_prefix
  project         = var.project
  environment     = var.environment
  vpc_id          = module.network.vpc_id
  vpc_cidr        = var.cidr
  pub_subnet_id   = module.network.pub_subnet_ids[0]
  ami_id          = data.aws_ami.bastion.id
  key_name        = local.key_name
  route53_zone_id = module.network.route53_zone_id
}

module "pipeline" {
  source             = "./pipeline"
  resource_prefix    = var.resource_prefix
  project            = var.project
  environment        = var.environment
  github_token       = var.github_token
  ecr_name           = module.eks.ecr_name
  location           = var.location
}