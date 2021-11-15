output "name" {
  description = "Name of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.name, [""]), 0)
}

output "id" {
  description = "ID of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.id, [""]), 0)
}

output "arn" {
  description = "ARN of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.arn, [""]), 0)
}

output "certificate_authority" {
  description = "Base 64 encoded certificate authority of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.certificate_authority.0.data, [""]), 0)
  sensitive   = true
}

output "endpoint" {
  description = "Endpoint of the EKS cluster that is created."
  value       = element(concat(aws_eks_cluster.this.*.endpoint, [""]), 0)
  sensitive   = true
}

output "iam_role_name" {
  description = "Name of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.name, [""]), 0)
}

output "iam_role_id" {
  description = "ID of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.id, [""]), 0)
}

output "iam_role_arn" {
  description = "ARN of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

output "iam_role_unique_id" {
  description = "Uniauq ID of the IAM role that is created."
  value       = element(concat(aws_iam_role.this.*.unique_id, [""]), 0)
}

output "security_group_name" {
  description = "Name of the security group that is created."
  value       = element(concat(aws_security_group.this.*.name, [""]), 0)
}

output "security_group_id" {
  description = "ID of the security group that is created."
  value       = element(concat(aws_security_group.this.*.id, [""]), 0)
}

output "security_group_arn" {
  description = "ARN of the security group that is created."
  value       = element(concat(aws_security_group.this.*.arn, [""]), 0)
}

output "worker_security_group_id" {
  description = "ID of the security group that is created for the workers"
  value       = element(concat(aws_security_group.worker.*.id, [""]), 0)
}

output "worker_security_group_arn" {
  description = "ARN of the security group that is created for the workers."
  value       = element(concat(aws_security_group.worker.*.arn, [""]), 0)
}

output "kubernetes_version" {
  description = "Version of the EKS cluster."
  value       = element(concat(aws_eks_cluster.this.*.version, [""]), 0)
}

output "kubernates_config_map_name" {
  description = "Config map for EKS workers"
  value       = element(concat(kubernetes_config_map.this.*.metadata.0.name, [""]), 0)
}

output "iam_openid_connect_provider_arn" {
  value = element(concat(aws_iam_openid_connect_provider.this.*.arn, [""]), 0)
}

output "iam_openid_connect_provider_url" {
  value = element(concat(aws_iam_openid_connect_provider.this.*.url, [""]), 0)
}

output "vpc_cni_addon_arn" {
  description = "ARN of the add-on vpc-cni."
  value       = element(concat(module.addons.*.thvpc_cni_addon_arn, [""]), 0)
}

output "coredns_addon_arn" {
  description = "ARN of the add-on coredns."
  value       = element(concat(module.addons.*.coredns_addon_arn, [""]), 0)
}

output "kube_proxy_addon_arn" {
  description = "ARN of the add-on kube-proxy."
  value       = element(concat(module.addons.*.kube_proxy_addon_arn, [""]), 0)
}
