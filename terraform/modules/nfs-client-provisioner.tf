resource "kubernetes_namespace" "nfs-client-provisioner" {
  metadata {
    name = "nfs-client-provisioner"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.nfs-storage]
}

resource "helm_release" "nfs-client-provisioner" {
  name       = "nfs-client-provisioner"
  chart      = "${path.module}/charts/nfs-client-provisioner"
  namespace  = "nfs-client-provisioner"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.nfs-client-provisioner]
}
