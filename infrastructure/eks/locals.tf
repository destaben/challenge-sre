locals {
  tags = merge(
    {
      "Project"          = var.project
      "Environment"      = var.environment
      "TerraformManaged" = "true"
    },
    {
      "K8sCluster"                       = var.cluster_id
      "k8s.io/cluster/${var.cluster_id}" = "owned"
    }
  )
}
