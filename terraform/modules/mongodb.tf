resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
    labels = {
      namespace = "mongodb"
    }
  }

  depends_on = [helm_release.nfs-server-provisioner]
}

resource "helm_release" "mongodb" {
  name       = "mongodb"
  chart      = "${path.module}/charts/mongodb"
  namespace  = "mongodb"
  version    = "0.1.0"

  recreate_pods = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/mongodb/values.yaml")
  ]

  depends_on = [kubernetes_namespace.mongodb]
}
