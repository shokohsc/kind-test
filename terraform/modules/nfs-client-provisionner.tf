resource "kubernetes_namespace" "nfs-client-provisionner" {
  metadata {
    name = "nfs-client-provisionner"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.nfs-storage]
}

resource "helm_release" "nfs-client-provisionner" {
  name       = "nfs-client-provisionner"
  chart      = "${path.module}/charts/nfs-client-provisionner"
  namespace  = "nfs-client-provisionner"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.nfs-client-provisionner]
}
