resource "aws_security_group" "eks_sg" {
  name        = "${var.resource_prefix}-sg-eks-01"
  description = "${var.project} EKS Security Group"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-sg-eks-01"
    },
    local.tags,
  )
}
resource "aws_security_group_rule" "egress_default_EKS" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_sg.id
}
resource "aws_security_group_rule" "allow_all_eks" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_sg.id
  security_group_id        = aws_security_group.eks_sg.id
}
resource "aws_security_group_rule" "allow_all_eks_bastion" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = var.aws_security_group_bastion
  security_group_id        = aws_security_group.eks_sg.id
}
