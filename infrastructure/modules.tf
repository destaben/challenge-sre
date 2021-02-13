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
  vpc_cidr                   = var.cidr
  location                   = var.location
  cluster_id                 = local.k8s_cluster_id
  vpc_id                     = module.network.vpc_id
  pri_subnet_ids             = module.network.pri_subnet_ids
  instance_type_workers      = var.instance_type_workers
  max_workers                = var.max_workers
  min_workers                = var.min_workers
  des_workers                = var.des_workers
  alerting_sms_number        = var.alerting_sms_number
  github_owner               = var.github_owner
}

module "pipeline" {
  source             = "./pipeline"
  resource_prefix    = var.resource_prefix
  project            = var.project
  environment        = var.environment
  github_token       = var.github_token
  ecr_name           = module.eks.ecr_name
  location           = var.location
  cluster_id         = module.eks.cluster_id
  kubectl_role_arn   = module.eks.kubectl_role_arn
  alerting_sms_number = var.alerting_sms_number
  vpc_id             = module.network.vpc_id
  pri_subnet_ids     = module.network.pri_subnet_ids
}