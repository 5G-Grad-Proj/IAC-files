module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "5G-Core-Net"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets


  # aws-auth configmap
  # create_aws_auth_configmap = true
  # manage_aws_auth_configmap = true

    cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 0
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
    ingress_source_security_group_id = {
      description              = "Ingress from another computed security group"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = aws_security_group.additional.id
    }
  }

  eks_managed_node_groups = {

    blue = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
    }
    green = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
    }
  }

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::989152389096:role/AWSServiceRoleForAmazonEKS"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::989152389096:user/Ahmad"
      username = "Ahmad-EKS"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::989152389096:user/root"
      username = "root"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::989152389096:user/islam"
      username = "islam"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    "989152389096"
  ]

  tags = {
    env = "prod"
    Terraform   = "true"
  }
}