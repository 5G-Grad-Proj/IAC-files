module "disabled_eks" {
  source = "../.."

  create = false
}

module "disabled_fargate_profile" {
  source = "../../modules/fargate-profile"

  create = false
}

module "disabled_eks_managed_node_group" {
  source = "../../modules/eks-managed-node-group"

  create = false
}

module "disabled_self_managed_node_group" {
  source = "../../modules/self-managed-node-group"

  create = false
}