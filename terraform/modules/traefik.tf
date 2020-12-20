resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
    labels = {
      namespace = "traefik"
    }
  }

  depends_on = [helm_release.metallb]
}

resource "helm_release" "traefik" {
  name       = "traefik"
  chart      = "${path.module}/charts/traefik"
  namespace  = "traefik"
  version    = "0.1.0"

  recreate_pods = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/traefik/values.yaml")
  ]

  depends_on = [kubernetes_namespace.traefik]
}
