resource "kubernetes_namespace" "traefik-system" {
  metadata {
    name = "traefik-system"
  }
}

resource "helm_release" "traefik" {
  name  = "traefik"
  chart = "traefik/traefik"
  namespace = "traefik-system"
}
