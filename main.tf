module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version        = "3.18.1"
  cidr = "10.0.0.0/16"
  azs     = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  tags = {
    Name = "eks-vpc"
  }
}

# Create an EKS cluster in the VPC
module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "my-eks-cluster"
  subnet_ids      = module.vpc.private_subnets
  eks_managed_node_groups = {
    node_group_name = "my-node-group"
    scaling_config = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
    }
    instance_types = ["t2.micro"]
  }
  self_managed_node_group_defaults = {
    instance_type                          = "t2.micro"
    update_launch_template_default_version = true
    iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }d
}
#   map_roles = [
#     {
#       rolearn  = aws_iam_role.eks_cluster.arn
#       username = "system:node:{{EC2PrivateDNSName}}"
#       groups   = ["system:bootstrappers", "system:nodes"]
#     }
#   ]
#   # Create a worker node IAM role
#   create_iam_role = true
# resource "aws_iam_role" "eks_cluster" {
#   name = "eks-cluster"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # Attach policies to the IAM role for the EKS cluster
# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_cluster.name
# }

# # Attach an additional policy to the IAM role for the EKS cluster
# resource "aws_iam_role_policy_attachment" "eks_cluster_additional_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = aws_iam_role.eks_cluster.name
# }
# resource "aws_iam_role" "eks_cluster" {
#   name = "eks-cluster"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach the necessary policies to the IAM role
# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_cluster.name
# }

# resource "aws_iam_role_policy_attachment" "eks_service_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = aws_iam_role.eks_cluster.name
# }