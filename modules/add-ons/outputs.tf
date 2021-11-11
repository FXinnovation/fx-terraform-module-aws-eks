output "vpc_cni_addon_arn" {
  description = "ARN of the add-on vpc-cni."
  value       = aws_eks_addon.this_vpc_cni.arn
}

output "coredns_addon_arn" {
  description = "ARN of the add-on coredns."
  value       = aws_eks_addon.this_coredns.arn
}

output "kube_proxy_addon_arn" {
  description = "ARN of the add-on kube-proxy."
  value       = aws_eks_addon.this_kube_proxy.arn
}
