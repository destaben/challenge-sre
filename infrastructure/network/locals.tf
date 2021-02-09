locals {
  tags = merge(
    {
      "Project"          = var.project
      "Environment"      = var.environment
      "TerraformManaged" = "true"
    },
    {
      for cluster_id in var.k8s_cluster_ids :
      "k8s.io/cluster/${cluster_id}" => "shared"
    }
  )
}
