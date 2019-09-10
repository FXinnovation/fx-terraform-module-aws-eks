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

#####
# Security groups for eks master
#####

resource "aws_security_group" "this_master" {
  name        = var.master_security_group_name
  description = "Master from/to worker node groups"
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
    var.master_security_group_tags
  )
}

resource "aws_security_group" "this_worker" {
  name        = var.worker_security_group_name
  description = "Worker node groups from/to master"
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
    security_groups = [aws_security_group.this_master.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.this_master.id]
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
    var.worker_security_group_tags
  )
}

#####
# IAM roles
#####

resource "aws_iam_role" "master" {
  name = var.master_iam_role_name

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

resource "aws_iam_role_policy_attachment" "master_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "master_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role" "worker" {
  name = var.worker_iam_role_name

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
  name        = var.ingress_policy_name
  path        = "/"
  description = "Allow ingress controllers to interact with elasticloadbalancing"

  policy = file("${path.module}/templates/alb-ingress-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker_container_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.worker.name
}

resource "aws_iam_instance_profile" "node" {
  name = var.worker_iam_instance_profile
  role = aws_iam_role.worker.name
}

#####
# Master and workers creation
#####

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.master.arn

  vpc_config {
    security_group_ids = concat([aws_security_group.this_master.id], var.security_group_ids)
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

data "template_file" "this" {
  template = file("${path.module}/templates/userdata.tpl")
  vars = {
    cluster_name        = var.cluster_name
    cluster_endpoint    = aws_eks_cluster.this.endpoint
    cluster_certificate = aws_eks_cluster.this.certificate_authority.0.data
  }
}

resource "aws_launch_configuration" "this" {
  associate_public_ip_address = var.worker_node_public_address
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = var.worker_ami == "" ? data.aws_ami.this.id : var.worker_ami
  instance_type               = var.worker_instance_type
  name_prefix                 = var.worker_name_prefix
  security_groups             = concat([aws_security_group.this_worker.id], var.security_group_ids)
  user_data_base64            = base64encode(data.template_file.this.rendered)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity     = var.worker_autoscalinggroup_desired_capacity
  launch_configuration = aws_launch_configuration.this.id
  max_size             = var.worker_autoscalinggroup_max_size
  min_size             = var.worker_autoscalinggroup_min_size
  name                 = var.worker_autoscalinggroup_name
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
    for_each = var.worker_autoscalinggroup_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate
    }
  }
}

#####
# Kubernetes configuration
#####

data "aws_eks_cluster_auth" "this" {
  depends_on = ["aws_eks_cluster.this"]
  name       = var.cluster_name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
  version                = "~> 1.9"
}

resource "kubernetes_config_map" "aws_auth" {
  count = var.alb_enabled == "true" ? 1 : 0
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.worker.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }

}

resource "kubernetes_service_account" "alb_ingress" {
  count = var.alb_enabled == "true" ? 1 : 0
  metadata {
    name = "alb-ingress"
    labels = {
      app = "alb-ingress-controller"
    }
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "alb_ingress_controller" {
  count = var.alb_enabled == "true" ? 1 : 0
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

resource "kubernetes_cluster_role_binding" "alb_ingress_controller" {
  count = var.alb_enabled == "true" ? 1 : 0
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
  count = var.alb_enabled == "true" ? 1 : 0
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
