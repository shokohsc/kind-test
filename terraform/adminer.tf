resource "kubernetes_namespace" "adminer" {
  metadata {
    name = "adminer"
  }
}

resource "helm_release" "adminer" {
  name       = "adminer"
  repository = "https://cetic.github.io/helm-charts" 
  chart      = "adminer"
  namespace  = "adminer"
  version    = "0.1.3"

  values = [
    "${file("adminer.yaml")}"
  ]
}
