provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
      # Adjust timeout value as needed (e.g., 30m)
      timeouts = {
        default = "30m"
      }
    }
  }
}
resource "helm_release" "karpenter" {
  #depends_on       = [module.eks.kubeconfig]
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.6.0"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }

  set {
    name  = "controller.clusterName"
    value = "my-cluster"
  }

  set {
    name  = "controller.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
}