#####
# Locals
#####

locals {
  tags = {
    "Terraform" = "true"
  }
  vpc_id = data.aws_subnet.this.vpc_id
}

#####
# EKS Cluster
#####

resource "aws_eks_cluster" "this" {
  count = var.enabled ? 1 : 0

  name     = var.name
  role_arn = element(concat(aws_iam_role.this.*.arn, list("")), 0)

  vpc_config {
    security_group_ids      = concat(aws_security_group.this.*.id, var.security_group_ids)
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.private_access
    endpoint_public_access  = var.public_access
  }

  tags = merge(
    local.tags,
    var.tags,
    var.eks_tags
  )
}

#####
# IAM
#####

resource "aws_iam_role" "this" {
  count = var.enabled ? 1 : 0

  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.this.json

}

resource "aws_iam_role_policy_attachment" "master_cluster_policy" {
  count = var.enabled ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = element(concat(aws_iam_role.this.*.name, list("")), 0)
}

resource "aws_iam_role_policy_attachment" "master_service_policy" {
  count = var.enabled ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = element(concat(aws_iam_role.this.*.name, list("")), 0)
}

#####
# Security group
#####

resource "aws_security_group" "this" {
  count = var.enabled ? 1 : 0

  name        = var.security_group_name
  description = "EKS Control Plane security group."
  vpc_id      = local.vpc_id

  tags = merge(
    local.tags,
    var.tags,
    var.security_group_tags
  )
}

resource "aws_security_group_rule" "this_ingress_443" {
  for_each = toset(var.allowed_security_group_ids)

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = each.key
  security_group_id        = element(concat(aws_security_group.this.*.id, list("")), 0)
}

resource "aws_security_group_rule" "allowed_egress_443" {
  for_each = toset(var.allowed_security_group_ids)

  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  security_group_id        = each.key
}
