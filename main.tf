#####
# Security groups for eks master
#####

resource "aws_security_group" "this_master" {
  name        = var.master_security_group_name
  description = "Master from/to worker node groups"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.master_security_group_tags
  )
}

resource "aws_security_group_rule" "from_worker_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this_worker.id
  security_group_id        = aws_security_group.this_master.id
}

resource "aws_security_group_rule" "to_worker_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this_worker.id
  security_group_id        = aws_security_group.this_master.id
}

resource "aws_security_group_rule" "to_worker_other" {
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this_worker.id
  security_group_id        = aws_security_group.this_master.id
}

resource "aws_security_group" "this_worker" {
  name        = var.worker_security_group_name
  description = "Worker node groups from/to master"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
    var.worker_security_group_tags
  )
}

resource "aws_security_group_rule" "from_master_other" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this_master.id
  security_group_id        = aws_security_group.this_worker.id
}

resource "aws_security_group_rule" "from_master_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this_master.id
  security_group_id        = aws_security_group.this_worker.id
}

resource "aws_security_group_rule" "self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.this_worker.id
}

resource "aws_security_group_rule" "to_master" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this_worker.id
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
  name     = var.name
  role_arn = aws_iam_role.master.arn

  vpc_config {
    security_group_ids      = concat([aws_security_group.this_master.id], var.security_group_ids)
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.master_private_access
    endpoint_public_access  = var.master_public_access
  }
}

data "aws_ami" "this" {
  filter {
    name   = "name"
    values = [var.ami_name]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "template_file" "this" {
  template = file("${path.module}/templates/userdata.tpl")
  vars = {
    cluster_name        = var.name
    cluster_endpoint    = aws_eks_cluster.this.endpoint
    cluster_certificate = aws_eks_cluster.this.certificate_authority.0.data
    use_max_pods = var.worker_use_max_pods
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
  desired_capacity     = var.worker_autoscaling_group_desired_capacity
  launch_configuration = aws_launch_configuration.this.id
  max_size             = var.worker_autoscaling_group_max_size
  min_size             = var.worker_autoscaling_group_min_size
  name                 = var.worker_autoscaling_group_name
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "terraform-eks"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.name}"
    value               = "owned"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.worker_autoscaling_group_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }
}

#####
# Kubernetes configuration
#####

resource "kubernetes_service_account" "efs" {
  metadata {
    name      = "efs-provisioner"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "efs-provisioner-runner"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "update", "patch"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "run-efs-provisioner"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "efs-provisioner-runner"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "efs-provisioner"
    namespace = var.namespace
  }
}

resource "kubernetes_role" "this" {
  metadata {
    name      = "leader-locking-efs-provisioner"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "leader-locking-efs-provisioner"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "leader-locking-efs-provisioner"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "efs-provisioner"
    namespace = var.namespace
  }
}

resource "kubernetes_config_map" "this" {
  metadata {
    name      = "efs-provisioner"
    namespace = var.namespace
  }

  data = {
    "file.system.id"   = var.efs_id
    "aws.region"       = var.region
    "provisioner.name" = "example.com/aws-efs"
    "dns.name"         = var.efs_dns_name
  }
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "aws-efs"
  }
  storage_provisioner = "example.com/aws-efs"
}

resource "kubernetes_deployment" "efs" {
  metadata {
    name      = "efs-provisioner"
    namespace = var.namespace
  }

  spec {
    replicas = 2
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "efs-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          app = "efs-provisioner"
        }
      }

      spec {
        service_account_name            = "efs-provisioner"
        automount_service_account_token = true
        container {
          image = "quay.io/external_storage/efs-provisioner:latest"
          name  = "efs-provisioner"

          env {
            name = "FILE_SYSTEM_ID"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "file.system.id"
              }
            }
          }
          env {
            name = "AWS_REGION"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "aws.region"
              }
            }
          }
          env {
            name = "DNS_NAME"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "dns.name"
              }
            }
          }
          env {
            name = "PROVISIONER_NAME"
            value_from {
              config_map_key_ref {
                name = "efs-provisioner"
                key  = "provisioner.name"
              }
            }
          }

          volume_mount {
            mount_path = "/persistentvolumes"
            name       = "pv-volume"
          }
        }
        volume {
          name = "pv-volume"
          nfs {
            path   = "/"
            server = var.efs_dns_name
          }
        }
      }
    }
  }
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
          args              = ["--ingress-class=alb", "--cluster-name=${var.name}", "--aws-region=${var.region}"]
          image             = "docker.io/amazon/aws-alb-ingress-controller:${var.alb_image_version}"
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
