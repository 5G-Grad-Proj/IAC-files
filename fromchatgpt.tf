#provider "helm" {
#  kubernetes {
#    config_path    = "~/.kube/config"
#    config_context = "${terraform.output.kubeconfig_context}"
#  }
#}
#
#data "github_repository" "free5gc" {
#  owner = "5G-Grad-Proj"
#  name  = "towards5gs-helm"
#}
#
#resource "helm_release" "free5gc" {
#  name       = "free5gc"
#  repository = "${data.github_repository.free5gc.clone_url}"
#  chart      = "free5gc"
#
#  values = [
#    "towards5gs-helm/charts/free5gc/values.yaml"
#  ]
#}
#