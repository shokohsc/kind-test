resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.metallb]
}

resource "helm_release" "traefik" {
  name       = "traefik"
  chart      = "${path.module}/charts/traefik"
  namespace  = "traefik"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.traefik]
}
