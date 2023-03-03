# Docker registry link
registry {
url = "https://registry.hub.docker.com/v2/"
}

resource "helm_release" "parent_chart" {
  name       = "chart of all charts"

  repository = "https://github.com/5G-Grad-Proj/towards5gs-helm/tree/main/charts/free5gc"
  chart      = "Chart.yaml"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}