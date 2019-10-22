resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

module "standard" {
  source = "../../"

  name                       = "terraform-jenkins-${random_string.this.result}"
  master_iam_role_name       = "terraform-eks-cluster-${random_string.this.result}"
  master_security_group_name = "aws-sg-eks-master-${random_string.this.result}"
  master_security_group_tags = {
    "Name" = "tooling-master-sg"
  }
  master_role_tags = {
    "Name" = "tooling-master-role"
  }
  worker_iam_role_name          = "terraform-eks-nodes-${random_string.this.result}"
  worker_instance_type          = "t2.small"
  worker_name_prefix            = "terraform-eks-node-${random_string.this.result}-"
  worker_autoscaling_group_name = "terraform-eks-asg-${random_string.this.result}"
  worker_security_group_name    = "aws-sg-eks-nodes-${random_string.this.result}"
  worker_iam_instance_profile   = "terraform-eks-node-${random_string.this.result}"
  worker_use_max_pods           = false
  worker_security_group_tags = {
    "Name" = "tooling-worker-sg"
  }
  worker_role_tags = {
    "Name" = "tooling-worker-role"
  }
  subnet_ids            = tolist(data.aws_subnet_ids.default.ids)
  master_private_access = true
}
