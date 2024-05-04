resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [module.eks]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-5.36.11/argo-cd-5.36.11.tgz"
  namespace  = "argocd"
  depends_on = [module.eks, kubernetes_namespace.argocd]
}

resource "kubectl_manifest" "argocd" {
    yaml_body = file("${path.module}/argocd.yaml")

    depends_on = [module.eks, helm_release.argocd]
}