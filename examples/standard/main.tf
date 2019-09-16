resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

module "standard" {
  source = "../../"

  cluster_name                  = "terraform-jenkins-${random_string.this.result}"
  aws_vpc                       = data.aws_vpc.default.id
  aws_vpc_cidr_block            = data.aws_vpc.default.cidr_block
  master_iam_role_name          = "terraform-eks-cluster-${random_string.this.result}"
  worker_iam_role_name          = "terraform-eks-nodes-${random_string.this.result}"
  ingress_policy_name           = "alb-ingress-controller-${random_string.this.result}"
  worker_instance_type          = "t2.xlarge"
  worker_name_prefix            = "terraform-eks-node-${random_string.this.result}"
  worker_autoscaling_group_name = "terraform-eks-asg-${random_string.this.result}"
  aws_subnet_ids                = data.aws_subnet_ids.default.ids
  master_security_group_name    = "aws-sg-eks-master-${random_string.this.result}"
  worker_security_group_name    = "aws-sg-eks-nodes-${random_string.this.result}"
  worker_iam_instance_profile   = "terraform-eks-node-${random_string.this.result}"
  alb_enabled                   = "true"
  region                        = data.aws_region.current.name
  alb_image_version             = "v1.1.3"
  efs_id                        = "fs-41426038"
  efs_dns_name                  = "fs-41426038.efs.us-east-2.amazonaws.com"
}
