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
