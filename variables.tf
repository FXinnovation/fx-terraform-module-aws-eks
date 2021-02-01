variable "allowed_security_group_ids" {
  description = "List of security group ID's that will be allowed to talk to the EKS cluster."
  type        = list(string)
  default     = []
}

variable "allowed_security_group_count" {
  description = "exact length of the `allowed_security_group_ids` variable."
  type        = number
}

variable "allowed_cidrs" {
  description = "List of CIDRs that will be allowed to talk to the EKS cluster."
  type        = list(string)
  default     = []
}

variable "aws_auth_configmap_data" {
  description = "List of maps that represent the aws-auth data needed for EKS to work properly. https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html for more information."
  default     = []
}

variable "eks_tags" {
  description = "Map of tags that will be applied on the EKS cluster."
  default     = {}
}

variable "enabled" {
  description = "Whether or not to enable this module."
  default     = true
}

variable "iam_role_name" {
  description = "Name of the IAM role for the EKS cluster."
  default     = "eks-cluster"
}

variable "iam_policy_name" {
  description = "Name of the additionnal IAM policy for the EKS cluster."
  default     = "eks-cluster"
}

variable "iam_role_tags" {
  description = "Map of tags that will be applied on the IAM role."
  default     = {}
}

variable "name" {
  description = "Name of the EKS cluster."
  default     = "eks-cluster"
}

variable "private_access" {
  description = "Whether or not to enable private access to the EKS endpoint."
  default     = false
}

variable "public_access" {
  description = "Whether or not to enable public access to the EKS endpoint."
  default     = true
}

variable "security_group_ids" {
  description = "List of additionnal security group ID's to set on the AKS cluster."
  default     = []
}

variable "security_group_name" {
  description = "Name of the security group for the EKS cluster."
  default     = "eks-cluster"
}

variable "security_group_tags" {
  description = "Map of tags that will be applied on the security group."
  default     = {}
}

variable "worker_security_group_name" {
  description = "Name of the security group for the EKS cluster."
  default     = "eks-workers-cluster"
}

variable "worker_security_group_tags" {
  description = "Map of tags that will be applied on the security group."
  default     = {}
}

variable "subnet_ids" {
  description = "List of subnet ID's where the EKS master will be available from."
  type        = list(string)
}

variable "tags" {
  description = "Map of tags that will be applied on all resources."
  default     = {}
}

variable "kubernetes_version" {
  description = "Version that will be used for the EKS cluster."
  default     = null
  type        = string
}

variable "kubernetes_aws_iam_integration_enabled" {
  description = "Whether or not to enable the IAM Integration in kubernetes (this will allow you to map AWS IAM roles to specific Kubernetes service acounts)"
  default     = true
}
