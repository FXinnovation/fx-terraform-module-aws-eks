output "name" {
  description = "Name of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.name, list("")), 0)
}

output "id" {
  description = "ID of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.id, list("")), 0)
}

output "arn" {
  description = "ARN of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.arn, list("")), 0)
}

output "certificate_authority" {
  description = "Base 64 encoded certificate authority of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.certificate_authority.0.data, list("")), 0)
  sensitive   = true
}

output "endpoint" {
  description = "Endpoint of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.endpoint, list("")), 0)
  sensitive   = true
}

output "iam_role_name" {
  description = "Name of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.name, list("")), 0)
}

output "iam_role_id" {
  description = "ID of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.id, list("")), 0)
}

output "iam_role_arn" {
  description = "ARN of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.arn, list("")), 0)
}

output "iam_role_unique_id" {
  description = "Uniauq ID of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.unique_id, list("")), 0)
}

output "security_group_name" {
  description = "Name of the security group that is created."
  value       = element(concat(aws_security_group.this.*.name, list("")), 0)
}

output "security_group_id" {
  description = "ID of the security group that is created."
  value       = element(concat(aws_security_group.this.*.id, list("")), 0)
}

output "security_group_arn" {
  description = "ARN of the security group that is created."
  value       = element(concat(aws_security_group.this.*.arn, list("")), 0)
}
