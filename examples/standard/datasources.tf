data "aws_eks_cluster" "this" {
  name = "terraform-jenkins-${random_string.this.result}"
}

data "aws_eks_cluster_auth" "this" {
  name = "terraform-jenkins-${random_string.this.result}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {}