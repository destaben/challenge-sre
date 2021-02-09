output "aws_security_group_eks_master" {
  value = aws_security_group.eks_sg.id
}

output "aws_security_group_eks_workers" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}
