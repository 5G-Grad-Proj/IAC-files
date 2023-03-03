provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

################################################################################

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "5G-CoreNet"
  }
}


resource "helm_release" "towards5gs" {
  name       = "free5gc"
  repository = "https://5g-grad-proj.github.io/towards5gs-helm/"
  chart      = "free5gc"
  version    = "0.1.0"

   set {
    name  = "image.repository"
    value = "nginx"
  }

  set {
    name  = "image.tag"
    value = "1.19.9"
  }
  
  set {
    name  = "mongo.replicaSet.enabled"
    value = "false"
  }

  set {
    name  = "smf.service.type"
    value = "NodePort"
  }

  set {
    name  = "nrf.service.type"
    value = "NodePort"
  }
}
