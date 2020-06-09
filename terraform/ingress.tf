resource "kubernetes_secret" "web_ingress_auth" {
  metadata {
    name      = "web-ingress-auth"
    namespace = "linkerd"
  }
  data = {
    auth = "admin:$apr1$n7Cu6gHl$E47ogf7CO8NRYjEjBOkWM.\n\n"
  }
  type = "Opaque"
}

resource "kubernetes_ingress" "web_ingress" {
  metadata {
    name      = "web-ingress"
    namespace = "linkerd"
    annotations = {
      "ingress.kubernetes.io/custom-request-headers" = "l5d-dst-override:linkerd-web.linkerd.svc.cluster.local:8084"
      "kubernetes.io/ingress.class" = "traefik"
      "traefik.ingress.kubernetes.io/auth-secret" = "web-ingress-auth"
      "traefik.ingress.kubernetes.io/auth-type" = "basic"
    }
  }
  spec {
    rule {
      host = "linkerd.shokohsc.home"
      http {
        path {
          backend {
            service_name = "linkerd-web"
            service_port = "8084"
          }
        }
      }
    }
  }
}

