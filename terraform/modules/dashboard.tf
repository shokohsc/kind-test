resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "dashboard"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  chart      = "${path.module}/charts/dashboard"
  namespace  = "dashboard"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.dashboard]
}
