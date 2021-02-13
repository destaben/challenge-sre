resource "null_resource" "cert_manager" {
  depends_on = [ aws_eks_cluster.eks ]
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/deploy/cert-manager.yaml"
  }
}

resource "helm_release" "cluster-additional-tools" {
  depends_on = [ null_resource.cert_manager ]
  name       = "cluster-additional-tools"
  chart      = "${path.module}/deploy/cluster-additional-tools"

  set {
    name  = "eksClusterName"
    value = var.cluster_id
  }

  set {
    name  = "awsDefaultRegion"
    value = var.location
  }
}