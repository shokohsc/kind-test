resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      namespace = "argocd"
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "${path.module}/charts/argocd"
  namespace  = "argocd"
  version    = "0.1.0"

  recreate_pods = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/argocd/values.yaml")
  ]

  depends_on = [kubernetes_namespace.argocd]
}
