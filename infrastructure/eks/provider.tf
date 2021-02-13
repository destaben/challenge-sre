provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_author.token
  version                = "~> 2.0.2"
}

data "aws_eks_cluster_auth" "eks_author" {
  name = var.cluster_id
}