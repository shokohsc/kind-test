resource "kubernetes_namespace" "mongo-express" {
  metadata {
    name = "mongo-express"
    labels = {
      namespace = "mongo-express"
    }
  }

  depends_on = [helm_release.traefik, helm_release.mongodb]
}

resource "helm_release" "mongo-express" {
  name       = "mongo-express"
  chart      = "${path.module}/charts/mongo-express"
  namespace  = "mongo-express"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/mongo-express/values.yaml")
  ]

  depends_on = [kubernetes_namespace.mongo-express]
}
