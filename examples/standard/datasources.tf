data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {}

data "aws_eks_cluster_auth" "this" {
  name = module.standard.name
}

locals {
  aws_auth_data = [
    {
      rolearn  = "fakearnbecauseitdoesntmatter"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
    }
  ]
}
