resource "aws_codebuild_project" "project_cb" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "${var.resource_prefix}-project-build"
  queued_timeout = 480
  service_role   = aws_iam_role.static_build_role.arn
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-project-build"
    },
    local.tags,
  )

  artifacts {
    encryption_disabled    = false
    name                   = "${var.resource_prefix}-build-${var.environment}"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = data.template_file.buildspec.rendered
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}