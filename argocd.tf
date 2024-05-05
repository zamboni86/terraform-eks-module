resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-5.36.11/argo-cd-5.36.11.tgz"
  namespace  = "argocd"
  create_namespace = true
  depends_on = [module.eks]
}

resource "kubectl_manifest" "argocd" {
    yaml_body = file("${path.module}/argocd.yaml")

    depends_on = [module.eks, helm_release.argocd]
}