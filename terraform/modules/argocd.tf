resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "${path.module}/charts/argocd"
  namespace  = "argocd"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.argocd]
}
