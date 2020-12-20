resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
    labels = {
      namespace = "metallb"
    }
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  chart      = "${path.module}/charts/metallb"
  namespace  = "metallb"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/metallb/values.yaml")
  ]

  depends_on = [kubernetes_namespace.metallb]
}
