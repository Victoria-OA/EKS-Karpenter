provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
data "aws_eks_cluster" "cluster" {
  name = "my-cluster"
}


resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.13.1"
  timeout    = 600

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.cluster.id
  }

  set {
    name  = "clusterEndpoint"
    value = data.aws_eks_cluster.cluster.endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

  depends_on = [module.eks]
}