output "master-sg" {
  value = aws_security_group.this_eks_controlplane.id
}

output "worker-sg" {
  value = aws_security_group.this_eks_nodes.id
}

output "master-role" {
  value = aws_iam_role.eks-master.id
}

output "worker-role" {
  value = aws_iam_role.eks-node.id
}

output "cluster" {
  value = aws_eks_cluster.this.id
}

output "worker-ami" {
  value = data.aws_ami.this.name
}

output "asg" {
  value = aws_autoscaling_group.this.id
}

output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_kubeconfig" {
  value = local.kubeconfig

  depends_on = [
    "aws_eks_cluster.this",
  ]
}
