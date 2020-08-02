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
  repository = "https://containous.github.io/traefik-helm-chart" 
  chart      = "traefik"
  namespace  = "traefik"
  version    = "8.9.1"

  values = [
    file("${path.module}/traefik.yaml")
  ]

  depends_on = [kubernetes_namespace.traefik]
}
