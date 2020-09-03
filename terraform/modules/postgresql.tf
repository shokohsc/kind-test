resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "postgresql"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.nfs-client-provisioner]
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  chart      = "${path.module}/charts/postgresql"
  namespace  = "postgresql"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.postgresql]
}
