output "aws_security_group_eks_master" {
  value = aws_security_group.eks_sg.id
}

output "aws_security_group_eks_workers" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "ecr_name" {
  value = aws_ecr_repository.ecr.name
}

output "cluster_id" {
  value = var.cluster_id
}

output "kubectl_role_arn" {
  value = aws_iam_role.eks_kubectl_role.arn
}