resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    name = "longhorn-system"
    labels = {
      namespace = "longhorn-system"
    }
  }

  depends_on = [helm_release.nfs-wd1to]
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  chart      = "${path.module}/charts/longhorn"
  namespace  = "longhorn-system"
  version    = "0.1.0"

  recreate_pods = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    "${file("charts/longhorn/values.yaml")}"
  ]

  depends_on = [kubernetes_namespace.longhorn-system]
}
