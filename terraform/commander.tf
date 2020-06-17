resource "kubernetes_manifest" "deployment_commander" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "commander"
      }
      "name" = "commander"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "commander"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "commander"
          }
        }
        "spec" = {
          "affinity" = {
            "nodeAffinity" = {
              "requiredDuringSchedulingIgnoredDuringExecution" = {
                "nodeSelectorTerms" = [
                  {
                    "matchExpressions" = [
                      {
                        "key" = "overwatch"
                        "operator" = "NotIn"
                        "values" = [
                          "sombra",
                        ]
                      },
                    ]
                  },
                ]
              }
            }
          }
          "containers" = [
            {
              "image" = "coderaiser/cloudcmd"
              "name" = "commander"
            },
          ]
          "hostname" = "commander"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_commander_lb" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "commander-lb"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 80
          "targetPort" = 8000
        },
      ]
      "selector" = {
        "app" = "commander"
      }
    }
  }
}

resource "kubernetes_manifest" "ingressroute_commander_ingr" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    "kind" = "IngressRoute"
    "metadata" = {
      "name" = "commander-ingr"
    }
    "spec" = {
      "entryPoints" = [
        "web",
      ]
      "routes" = [
        {
          "kind" = "Rule"
          "match" = "Host(`kind.shokohsc.home`)"
          "services" = [
            {
              "name" = "commander-lb"
              "port" = 80
            },
          ]
        },
      ]
    }
  }
}
