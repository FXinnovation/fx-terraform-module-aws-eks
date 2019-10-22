#####
# Datasource
#####

data "aws_subnet" "this" {
  id = var.subnet_ids[0]
}

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
# Security groups for eks master
#####

resource "aws_security_group" "this_master" {
  name        = var.master_security_group_name
  description = "Master from/to worker node groups"
  vpc_id      = local.vpc_id

  tags = merge(
    local.tags,
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
  vpc_id      = local.vpc_id

  tags = merge(
    local.tags,
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
    local.tags,
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
    local.tags,
    var.tags,
    var.worker_role_tags
  )
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

resource "aws_launch_configuration" "this" {
  associate_public_ip_address = var.worker_node_public_address
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = var.worker_ami == "" ? data.aws_ami.this.id : var.worker_ami
  instance_type               = var.worker_instance_type
  name_prefix                 = var.worker_name_prefix
  security_groups             = concat([aws_security_group.this_worker.id], var.security_group_ids)
  user_data_base64 = base64encode(
    templatefile(
      "${path.module}/templates/userdata.tpl",
      {
        cluster_name        = var.name,
        cluster_endpoint    = aws_eks_cluster.this.endpoint,
        cluster_certificate = aws_eks_cluster.this.certificate_authority.0.data,
        use_max_pods        = var.worker_use_max_pods
      }
    )
  )

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
