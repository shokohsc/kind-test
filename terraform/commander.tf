resource "kubernetes_deployment" "commander" {
  metadata {
    name = "commander"
    labels = {
      app = "commander"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "commander"
      }
    }
    template {
      metadata {
        labels = {
          app = "commander"
        }
        annotations = {
            "linkerd.io/inject" = "enabled"
        }
      }
      spec {
        container {
          name  = "commander"
          image = "coderaiser/cloudcmd"
        }
        hostname = "commander"
      }
    }
  }
}

resource "kubernetes_ingress" "commander_ingress" {
  metadata {
    name      = "commander-ingress"
    namespace = "linkerd"
    annotations = {
      "ingress.kubernetes.io/custom-request-headers" = "l5d-dst-override:commander.default.svc.cluster.local:8000"
    }
  }
  spec {
    rule {
      host = "kind.shokohsc.home"
      http {
        path {
          backend {
            service_name = "commander"
            service_port = "8000"
          }
        }
      }
    }
  }
}

