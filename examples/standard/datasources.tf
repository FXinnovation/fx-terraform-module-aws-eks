data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_eks_cluster" "this" {
  name = module.standard.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.standard.cluster_name
}

data "aws_region" "current" {}
