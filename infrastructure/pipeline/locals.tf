locals {
  webhook_secret = "super-secret"
  tags = merge(
    {
      "Project"          = var.project
      "Environment"      = var.environment
      "TerraformManaged" = "true"
    }
  )
}
