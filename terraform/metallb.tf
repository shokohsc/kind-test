resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://charts.bitnami.com/bitnami" 
  chart      = "metallb"
  namespace  = "metallb"
  version    = "0.1.17"

  values = [
    "${file("metallb.yaml")}"
  ]
}