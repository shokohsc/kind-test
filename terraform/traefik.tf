resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://containous.github.io/traefik-helm-chart" 
  chart      = "traefik"
  namespace  = "traefik"
  version    = "8.9.1"

  values = [
    "${file("traefik.yaml")}"
  ]
}
