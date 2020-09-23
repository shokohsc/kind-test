resource "kubernetes_namespace" "nfs-server-provisioner" {
  metadata {
    name = "nfs-server-provisioner"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "nfs-server-provisioner" {
  name       = "nfs-server-provisioner"
  chart      = "${path.module}/charts/nfs-server-provisioner"
  namespace  = "nfs-server-provisioner"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.nfs-server-provisioner]
}
