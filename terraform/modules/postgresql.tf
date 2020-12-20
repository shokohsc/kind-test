resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "postgresql"
    labels = {
      namespace = "postgresql"
    }
  }

  depends_on = [helm_release.nfs-server-provisioner]
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  chart      = "${path.module}/charts/postgresql"
  namespace  = "postgresql"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/postgresql/values.yaml")
  ]

  depends_on = [kubernetes_namespace.postgresql]
}
