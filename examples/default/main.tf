resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

resource "aws_security_group" "standard" {
  name        = "test-eks${random_string.this.result}"
  description = "This security group is only here to test the eks ${random_string.this.result} allowed security group"
  vpc_id      = data.aws_vpc.default.id
}

module "standard" {
  source = "../../"

  providers = {
    kubernetes = kubernetes
  }

  iam_role_name                = random_string.this.result
  iam_policy_name              = random_string.this.result
  name                         = random_string.this.result
  security_group_name          = random_string.this.result
  worker_security_group_name   = "worker-${random_string.this.result}"
  subnet_ids                   = tolist(data.aws_subnet_ids.default.ids)
  aws_auth_configmap_data      = local.aws_auth_data
  allowed_cidrs                = ["127.0.0.1/32"]
  allowed_security_group_ids   = [aws_security_group.standard.id]
  allowed_security_group_count = 1
  kubernetes_version           = "1.21"
  eks_addons = [
    {
      name    = "vpn-cni"
      version = "v1.9.1-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.4-eksbuild.1"
    },
    {
      name    = "kube-proxy"
      version = "v1.21.2-eksbuild.2"
    }
  ]
}
