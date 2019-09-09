output "master-sg-id" {
  value = aws_security_group.this_eks_controlplane.id
}

output "worker-sg-id" {
  value = aws_security_group.this_eks_nodes.id
}

output "master-role-id" {
  value = aws_iam_role.eks-master.id
}

output "worker-role-id" {
  value = aws_iam_role.eks-node.id
}

output "cluster-name" {
  value = aws_eks_cluster.this.id
}

output "worker-asg-id" {
  value = aws_autoscaling_group.this.id
}

output "eks-cluster-endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster-public-certificate" {
  value = aws_eks_cluster.this.certificate_authority.0.data
}

output "efs-id" {
  value = aws_efs_file_system.this.id
}
