#####
# Locals
#####

locals {
  tags = {
    "Terraform" = "true"
  }
}

#####
# Add-ons
#####

resource "aws_eks_addon" "this_vpc_cni" {
  cluster_name      = var.cluster_name
  addon_name        = "vpc-cni"
  addon_version     = var.vpc_cni_addon_version
  resolve_conflicts = "OVERWRITE"
  tags              = local.tags
}

resource "aws_eks_addon" "this_coredns" {
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.coredns_addon_version
  resolve_conflicts = "OVERWRITE"
  tags              = local.tags
}

resource "aws_eks_addon" "this_kube_proxy" {
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy_addon_version
  resolve_conflicts = "OVERWRITE"
  tags              = local.tags
}
