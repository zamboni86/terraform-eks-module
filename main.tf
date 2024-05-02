module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  public_subnets  = ["10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19"]

  enable_nat_gateway = true

  tags = {
    terraform = "true"
    environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "example-cluster"
  cluster_version = "1.29"

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
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["m5.large"]
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = {
    environment = "dev"
    terraform   = "true"
  }

  depends_on = [
    module.vpc
  ]
}