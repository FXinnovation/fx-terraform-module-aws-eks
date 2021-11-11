variable "cluster_name" {
  description = "Name of the EKS cluster to be joined by add-ons."
  type        = string
}

variable "vpc_cni_addon_version" {
  description = "Version of the vpc cni add-on."
  type        = string
}

variable "coredns_addon_version" {
  description = "Version of the core dns add-on."
  type        = string
}

variable "kube_proxy_addon_version" {
  description = "Version of the kube-proxy add-on."
  type        = string
}
