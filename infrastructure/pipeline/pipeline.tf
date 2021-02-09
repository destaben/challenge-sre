resource "aws_codepipeline" "rest_pipeline" {
  name     = "${var.resource_prefix}-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn
  tags = {
    Environment = var.environment
  }

  artifact_store {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "Branch"               = "main"
        "Owner"                = "destaben"
        "PollForSourceChanges" = "false"
        "Repo"                 = "challenge-sre"
        "OAuthToken"           = var.github_token
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "ThirdParty"
      provider  = "GitHub"
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "environment"
              type  = "PLAINTEXT"
              value = var.environment
            },
          ]
        )
        "ProjectName" = aws_codebuild_project.project_cb.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
}