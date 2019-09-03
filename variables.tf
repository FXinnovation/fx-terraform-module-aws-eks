variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = "string"
}

variable "master_security_group_name" {
  description = "Name of the eks master security group."
  default     = "aws-sg-eks-master"
}

variable "node_security_group_name" {
  description = "Name of the eks nodes security group."
  default     = "aws-sg-eks-nodes"
}


variable "keypair-name" {
  description = "Name of the ssh key pair to deploy on worker nodes"
  type        = "string"
}
