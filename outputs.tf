output "master_security_group_id" {
  value = aws_security_group.this_master.id
}

output "master_role_id" {
  value = aws_iam_role.master.id
}

output "worker_security_group_id" {
  value = aws_security_group.this_worker.id
}

output "worker_role_id" {
  value = aws_iam_role.worker.id
}

output "worker_autoscaling_group_id" {
  value = aws_autoscaling_group.this.id
}

output "cluster_name" {
  value = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_public_certificate" {
  value     = aws_eks_cluster.this.certificate_authority.0.data
  sensitive = true
}
