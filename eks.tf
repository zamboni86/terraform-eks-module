module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "${var.env}-cluster"
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${var.account_number}:role/tf-project-codepipeline-role"
      username = "cicd"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${var.account_number}/zanoni.contreras"
      username = "admin"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    var.account_number
  ]

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
      min_size     = 3
      max_size     = 10
      desired_size = 3  

      instance_types = ["m5.large"]
      capacity_type  = "ONDEMAND"
    }
    
  }

  tags = local.tags

  depends_on = [
    module.vpc
  ]
}