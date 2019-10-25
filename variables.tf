variable "allowed_security_group_ids" {
  description = "List of security group ID's that will be allowed to talk to the EKS cluster."
  type        = list(string)
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
  default     = true
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

variable "subnet_ids" {
  description = "List of subnet ID's where the EKS master will be available from."
  type        = list(string)
}

variable "tags" {
  description = "Map of tags that will be applied on all resources."
  default     = {}
}
