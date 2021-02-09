locals {
  k8s_cluster_id = lower("${var.project}-${var.environment}-eks-01")
  domain_name = lower("${var.environment}.${var.project}.internal")
  key_name = lower("${var.project}${var.environment}.pub")
}
