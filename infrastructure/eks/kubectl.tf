data "aws_iam_policy_document" "kubectl_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "group_kubectl_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = [aws_iam_role.eks_kubectl_role.arn]
  }
}

resource "aws_iam_policy" "group_kubectl_assume_role_policy" {
  name        = "${var.resource_prefix}-iam-eksecr-01"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.group_kubectl_assume_role_policy.json
}

resource "aws_iam_group" "group_kubectl_assume_role_policy" {
  name = "${var.resource_prefix}-iam-eksecr-01"
}

resource "aws_iam_group_policy_attachment" "group_kubectl_assume_role_policy" {
  group      = aws_iam_group.group_kubectl_assume_role_policy.name
  policy_arn = aws_iam_policy.group_kubectl_assume_role_policy.arn
}

resource "aws_iam_role" "eks_kubectl_role" {
  name               = "kubectl-access-role"
  assume_role_policy = data.aws_iam_policy_document.kubectl_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_kubectl_amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_kubectl_role.name
}

resource "aws_iam_role_policy_attachment" "eks_kubectl_amazon_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_kubectl_role.name
}

resource "aws_iam_role_policy_attachment" "eks_kubectl_amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_kubectl_role.name
}

resource "aws_iam_role_policy_attachment" "eks_kubectl_amazon_ec2_container_registry_full" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.eks_kubectl_role.name
}


resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
      mapRoles = <<YAML
  - rolearn: ${aws_iam_role.eks_kubectl_role.arn}
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  - rolearn: ${aws_iam_role.eks_kubectl_role.arn}
    username: kubectl-access-role
    groups:
      - system:masters
  YAML
    }
}