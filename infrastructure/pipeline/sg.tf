resource "aws_security_group" "codebuild_sg" {
  name        = "${var.resource_prefix}-sg-codebuild-01"
  description = "${var.project} Codebuild Security Group"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-sg-codebuild-01"
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "egress_default_codebuild" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.codebuild_sg.id
}

resource "aws_security_group_rule" "ingress_default_codebuild" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.codebuild_sg.id
}

