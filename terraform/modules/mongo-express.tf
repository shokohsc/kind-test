resource "kubernetes_namespace" "mongo-express" {
  metadata {
    name = "mongo-express"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.traefik, helm_release.mongodb]
}

resource "helm_release" "mongo-express" {
  name       = "mongo-express"
  chart      = "${path.module}/charts/mongo-express"
  namespace  = "mongo-express"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.mongo-express]
}
