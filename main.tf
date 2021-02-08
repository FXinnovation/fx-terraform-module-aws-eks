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
  version  = var.kubernetes_version

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

  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    aws_security_group_rule.this_ingress_443,
    aws_security_group_rule.this_ingress_443_cidrs,
    aws_security_group_rule.this_allowed_egress_443,
    aws_iam_role_policy_attachment.master_cluster_policy,
    aws_iam_role_policy_attachment.master_service_policy
  ]
}

#####
# IAM
#####

resource "aws_iam_role" "this" {
  count = var.enabled ? 1 : 0

  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.this.json

}

resource "aws_iam_policy" "this" {
  count = var.enabled ? 1 : 0

  name   = var.iam_policy_name
  policy = data.aws_iam_policy_document.allow_ec2_describe.json
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

resource "aws_iam_role_policy_attachment" "master_missing_policy_from_aws" {
  count = var.enabled ? 1 : 0

  policy_arn = element(concat(aws_iam_policy.this.*.arn, list("")), 0)
  role       = element(concat(aws_iam_role.this.*.name, list("")), 0)
}

#####
# Security group
#####

# Master SG

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
  count = var.enabled ? var.allowed_security_group_count : 0

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
  security_group_id        = element(concat(aws_security_group.this.*.id, list("")), 0)
  description              = "Allow tcp/443 from allowed security groups"
}

resource "aws_security_group_rule" "this_ingress_443_worker" {
  count = var.enabled ? 1 : 0

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.worker.*.id, list("")), 0)
  security_group_id        = element(concat(aws_security_group.this.*.id, list("")), 0)
  description              = "Allow tcp/443 from worker security group"
}

resource "aws_security_group_rule" "this_ingress_443_cidrs" {
  count             = var.enabled ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  description       = "Allow tcp/443 from allowed CIDRs"
}

resource "aws_security_group_rule" "this_allowed_egress_443" {
  count = var.enabled ? var.allowed_security_group_count : 0

  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  security_group_id        = var.allowed_security_group_ids[count.index]
  description              = "Allow tcp/443 to allowed security groups"
}

resource "aws_security_group_rule" "this_allowed_egress_highports" {
  count = var.enabled ? var.allowed_security_group_count : 0

  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  security_group_id        = var.allowed_security_group_ids[count.index]
  description              = "Allow tcp/1025-65535 to allowed security groups"
}

resource "aws_security_group_rule" "this_allowed_egress_worker_443" {
  count                    = var.enabled ? 1 : 0
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.worker.*.id, list("")), 0)
  security_group_id        = element(concat(aws_security_group.this.*.id, list("")), 0)
  description              = "Allow tcp/443 to worker security group"
}

resource "aws_security_group_rule" "this_allowed_egress_worker_highports" {
  count                    = var.enabled ? 1 : 0
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.worker.*.id, list("")), 0)
  security_group_id        = element(concat(aws_security_group.this.*.id, list("")), 0)
  description              = "Allow tcp/1025-65535 to worker security group"
}

resource "aws_security_group_rule" "this_allowed_egress_cidrs_443" {
  count             = var.enabled ? 1 : 0
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  description       = "Allow tcp/443 to allowed CIDRs"
}

resource "aws_security_group_rule" "this_allowed_egress_cidrs_highports" {
  count             = var.enabled ? 1 : 0
  type              = "egress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  description       = "Allow tcp/1025-65535 to allowed CIDRs"
}

# Worker SG

resource "aws_security_group" "worker" {
  count = var.enabled ? 1 : 0

  name        = var.worker_security_group_name
  description = "Worker Pool EKS security group."
  vpc_id      = local.vpc_id

  tags = merge(
    local.tags,
    var.tags,
    var.worker_security_group_tags
  )
}

resource "aws_security_group_rule" "worker_ingress_self_any" {
  count = var.enabled ? 1 : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = element(concat(aws_security_group.worker.*.id, list("")), 0)
  description       = "Allow all traffic from itself"
}

resource "aws_security_group_rule" "worker_ingress_controlplane_443" {
  count = var.enabled ? 1 : 0

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  security_group_id        = element(concat(aws_security_group.worker.*.id, list("")), 0)
  description              = "Allow tcp/443 from control plane"
}

resource "aws_security_group_rule" "worker_ingress_controlplane_highports" {
  count = var.enabled ? 1 : 0

  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.this.*.id, list("")), 0)
  security_group_id        = element(concat(aws_security_group.worker.*.id, list("")), 0)
  description              = "Allow tcp/1025-65535 from control plane"
}

resource "aws_security_group_rule" "worker_egress_any" {
  count = var.enabled ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = element(concat(aws_security_group.worker.*.id, list("")), 0)
  description       = "Allow all outgoing traffic"
}

#####
# k8s auth
#####

resource "kubernetes_config_map" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    "mapRoles" = yamlencode(var.aws_auth_configmap_data)
  }
}

#####
# k8s IAM integration
#####

resource "aws_iam_openid_connect_provider" "this" {
  count = var.enabled && var.kubernetes_aws_iam_integration_enabled ? 1 : 0

  url = element(concat(aws_eks_cluster.this.*.identity.0.oidc.0.issuer, list("")), 0)

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = data.tls_certificate.this.*.certificates.0.sha1_fingerprint
}
