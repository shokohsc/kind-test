resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.linkerd]
}

resource "helm_release" "metallb" {
  name       = "metallb"
  chart      = "${path.module}/charts/metallb"
  namespace  = "metallb"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.metallb]
}