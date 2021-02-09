data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_eks_cluster" "eks" {
  version                   = 1.18
  name                      = var.cluster_id
  role_arn                  = aws_iam_role.eks-master-iam.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = [aws_security_group.eks_sg.id]
    subnet_ids              = var.pri_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  tags = merge(
    {
      "Name" = var.cluster_id
    },
    local.tags,
  )
  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.eks_cloudwatch_group,
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  release_version = "1.18.9-20210125"
  version         = aws_eks_cluster.eks.version
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.resource_prefix}-eks-node-group-01"
  node_role_arn   = aws_iam_role.eks-node-iam.arn
  subnet_ids      = var.pri_subnet_ids
  scaling_config {
    desired_size = var.des_workers
    max_size     = var.max_workers
    min_size     = var.min_workers
  }
  instance_types = [var.instance_type_workers]
  #remote_access {
  #  ec2_ssh_key = "${var.resource_prefix}keypair"
  #}
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-node-AmazonCloudwatch,
  ]
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-eks-node-group-01"
    },
    local.tags,
  )
}

resource "aws_cloudwatch_log_group" "eks_cloudwatch_group" {
  name              = "/aws/eks/${var.cluster_id}/cluster"
  retention_in_days = 7
}
