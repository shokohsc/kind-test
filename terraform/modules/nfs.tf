resource "kubernetes_namespace" "nfs" {
  metadata {
    name = "nfs"
    labels = {
      namespace = "nfs"
    }
  }
}

resource "helm_release" "nfs-wd1to" {
  name       = "nfs-wd1to"
  chart      = "${path.module}/charts/nfs-wd1to"
  namespace  = "nfs"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/nfs-wd1to/values.yaml")
  ]

  depends_on = [kubernetes_namespace.nfs]
}

resource "helm_release" "nfs-wd2to" {
  name       = "nfs-wd2to"
  chart      = "${path.module}/charts/nfs-wd2to"
  namespace  = "nfs"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/nfs-wd2to/values.yaml")
  ]

  depends_on = [kubernetes_namespace.nfs]
}

resource "helm_release" "nfs-shared" {
  name       = "nfs-shared"
  chart      = "${path.module}/charts/nfs-shared"
  namespace  = "nfs"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/nfs-shared/values.yaml")
  ]

  depends_on = [kubernetes_namespace.nfs]
}
