provider "aws" {
  version    = "~> 2.7.0"
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

provider "random" {
  version = "~> 2.0"
}

resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

module "standard" {
  source = "../../"

  cluster_name               = "terraform-jenkins-${random_string.this.result}"
  aws_vpc                    = data.aws_vpc.default.id
  aws_vpc_cidr_block         = data.aws_vpc.default.cidr_block
  eks_master_iam_role_name   = "terraform-eks-cluster-${random_string.this.result}"
  eks_worker_iam_role_name   = "terraform-eks-nodes-${random_string.this.result}"
  eks_ingress_policy         = "alb-ingress-controller"
  worker_instance_type       = "m5.xlarge"
  worker_name_prefix         = "terraform-eks-node-${random_string.this.result}"
  worker_asg_name            = "terraform-eks-asg-${random_string.this.result}"
  efs_name                   = "terraform-jenkins-${random_string.this.result}"
  efs_security_group_name    = "default"
  aws_subnet_ids             = data.aws_subnet_ids.default.ids
  master_security_group_name = "aws-sg-eks-master-${random_string.this.result}"
  node_security_group_name   = "aws-sg-eks-nodes-${random_string.this.result}"

}
