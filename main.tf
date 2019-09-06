resource "aws_efs_file_system" "this" {
  encrypted = true

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.efs_file_system_tags
  )
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.aws_subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = tolist(var.aws_subnet_ids)[count.index]
}

##################################
# Security groups for eks master #
##################################

resource "aws_security_group" "this_eks_controlplane" {
  name        = var.master_security_group_name
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = var.aws_vpc

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.aws_vpc_cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.aws_vpc_cidr_block]
  }

  egress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.aws_vpc_cidr_block]
  }

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.sg_control_plane_tags
  )
}

resource "aws_security_group" "this_eks_nodes" {
  name        = var.node_security_group_name
  description = "Communication between the control plane and worker nodes"
  vpc_id      = var.aws_vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.this_eks_controlplane.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.this_eks_controlplane.id]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.sg_workers_tags
  )
}

######################################################
# Setup for IAM roles needed to setup an EKS cluster #
######################################################

resource "aws_iam_role" "eks-master" {
  name = var.eks_master_iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.master_role_tags
  )
}

resource "aws_iam_role_policy_attachment" "eks-master-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-master.name
}

resource "aws_iam_role_policy_attachment" "eks-master-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-master.name
}

resource "aws_iam_role" "eks-node" {
  name = var.eks_worker_iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.worker_role_tags
  )
}

resource "aws_iam_policy" "this" {
  name        = var.eks_ingress_policy
  path        = "/"
  description = "Allow ingress controllers to interact with elasticloadbalancing"

  policy = file("${path.module}/templates/alb-ingress-controller-policy.template")
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "alb-ingress-controller" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_instance_profile" "node" {
  name = "terraform-eks-node"
  role = aws_iam_role.eks-node.name
}

###############################
# Master and workers creation #
###############################

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-master.arn

  vpc_config {
    security_group_ids = concat([aws_security_group.this_eks_controlplane.id], var.security_group_ids)
    subnet_ids         = flatten(var.aws_subnet_ids)
  }
}

data "aws_ami" "this" {
  filter {
    name   = "name"
    values = [var.eks_ami]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.this.endpoint}' --b64-cluster-ca '${aws_eks_cluster.this.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "this" {
  associate_public_ip_address = var.worker_node_public_address
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = var.worker_ami == "" ? data.aws_ami.this.id : var.worker_ami
  instance_type               = var.worker_instance_type
  name_prefix                 = var.worker_name_prefix
  security_groups             = concat([aws_security_group.this_eks_nodes.id], var.security_group_ids)
  user_data_base64            = var.eks_node_userdata == "" ? base64encode(local.eks-node-userdata) : var.eks_node_userdata

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity     = var.worker_asg_desired_capacity
  launch_configuration = aws_launch_configuration.this.id
  max_size             = var.worker_asg_max_size
  min_size             = var.worker_asg_min_size
  name                 = var.worker_asg_name
  vpc_zone_identifier  = flatten(var.aws_subnet_ids)

  tag {
    key                 = "Name"
    value               = "terraform-tf-eks"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.worker_asg_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate
    }
  }
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

############################
# Kubernetes configuration #
############################

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
  version                = "~> 1.5"
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.eks-node.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }

}

resource "kubernetes_service_account" "alb-ingress" {
  metadata {
    name = "alb-ingress"
    labels = {
      app = "alb-ingress-controller"
    }
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "alb-ingress-controller" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      app = "alb-ingress-controller"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "alb-ingress-controller" {
  metadata {
    labels = {
      app = "alb-ingress-controller"
    }
    name = "alb-ingress-controller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "alb-ingress-controller"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "alb-ingress"
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      app = "alb-ingress-controller"
    }
    namespace = "kube-system"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "alb-ingress-controller"
      }
    }

    strategy {
      rolling_update {
        max_surge       = 1
        max_unavailable = 1
      }
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "alb-ingress-controller"
        }
      }

      spec {
        container {
          args              = ["--ingress-class=alb", "--cluster-name=${var.cluster_name}", "--aws-region=us-east-2"]
          image             = "894847497797.dkr.ecr.us-west-2.amazonaws.com/aws-alb-ingress-controller:v1.0.0"
          name              = "server"
          image_pull_policy = "Always"

          resources {}

        }
        service_account_name            = "alb-ingress"
        automount_service_account_token = true
      }
    }
  }
}
