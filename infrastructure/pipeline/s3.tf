data "template_file" "s3_policy" {
  template = file("${path.module}/s3_policy.json")
  vars = {
    bucket_name = "${var.resource_prefix}-artifact-build"
  }
}

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket        = "${var.resource_prefix}-artifact-build"
  force_destroy = true
}