resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }
  depends_on = [helm_release.linkerd]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm" 
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "2.5.4"

  values = [
    "${file("argocd.yaml")}"
  ]
  depends_on = [kubernetes_namespace.argocd]
}