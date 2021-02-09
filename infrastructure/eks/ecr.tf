resource "aws_ecr_repository" "ecr" {
  name                 = "${var.resource_prefix}-ecr-01"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-ecr-01"
    },
    local.tags,
  )
}