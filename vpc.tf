module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-vpc"
  cidr = var.cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.subnets
  public_subnets  = []

  enable_nat_gateway = true

  tags = local.tags
}
