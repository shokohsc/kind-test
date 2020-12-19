resource "kubernetes_namespace" "nfs-server-provisioner" {
  metadata {
    name = "nfs-server-provisioner"
    labels = {
      namespace = "nfs-server-provisioner"
    }
  }

#  depends_on = [helm_release.linkerd]
}

resource "helm_release" "nfs-server-provisioner" {
  name       = "nfs-server-provisioner"
  chart      = "${path.module}/charts/nfs-server-provisioner"
  namespace  = "nfs-server-provisioner"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    "${file("charts/nfs-server-provisioner/values.yaml")}"
  ]

  depends_on = [kubernetes_namespace.nfs-server-provisioner]
}
