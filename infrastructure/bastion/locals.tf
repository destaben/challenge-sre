locals {
  tags = merge(
    {
      "Project"          = var.project
      "Environment"      = var.environment
      "TerraformManaged" = "true"
    }
  )
}
