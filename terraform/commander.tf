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

resource "kubernetes_service" "commander_lb" {
  metadata {
    name = "commander-lb"
  }
  spec {
    port {
      port        = 80
      target_port = "8000"
    }
    selector = {
      app = "commander"
    }
    type = "LoadBalancer"
  }
}

