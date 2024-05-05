module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "${var.env}-cluster"
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    aws-ebs-csi-driver = { 
      most_recent = true 
    }
  }
  
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m5.large"]
  }

  eks_managed_node_groups = {
    example = {
      name         = "example"
      min_size     = 3
      max_size     = 10
      desired_size = 3  

      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"

      # Needed by the aws-ebs-csi-driver
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
    
  }

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = ["admin"]
      principal_arn     = "arn:aws:iam::${var.account_number}:role/${env}-eks-codepipeline-role"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      },
      kubernetes_groups = ["admin"]
      principal_arn     = "arn:aws:iam::${var.account_number}:user/zanoni.contreras"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
  
  tags = local.tags

  depends_on = [
    module.vpc
  ]
}