provider "aws" {
  region = local.region
}

provider "kubernetes" {
  version = "~> 2.3"

  # Configure authentication with the EKS cluster
  load_config_file       = false
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = module.eks.worker_iam_oidc_provider_token

  # Configure RBAC permissions
  config_context_auth_info = module.eks.kubeconfig_authenticator
  config_context_cluster   = module.eks.kubeconfig_cluster

  # Configure resource prefix
  namespace = "default"
}

# DATA SOURCES
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}