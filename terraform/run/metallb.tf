resource "kubernetes_namespace" "metallb-system" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb" {
  name  = "metallb"
  chart = "stable/metallb"
  namespace = "metallb-system"
  values = [
    "${file("values.yaml")}"
  ]
}
