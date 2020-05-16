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
        affinity {
          nodeAffinity {
            requiredDuringSchedulingIgnoredDuringExecution {
              nodeSelectorTerms {
                matchExpressions {
                  key = "overwatch"
                  operator = "NotIn"
                  values = [ "sombra" ]
                }
              }
            }
          }
        }
        hostname = "commander"
        container {
          image = "coderaiser/cloudcmd"
          name  = "commander"
        }
      }
    }
  }
}

resource "kubernetes_service" "lb" {
  metadata {
    name = "commander-lb"
  }
  spec {
    selector = {
      app = "commander"
    }
    port {
      port        = 80
      target_port = 8000
    }
    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.commander.load_balancer_ingress[0].ip
}
