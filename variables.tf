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

variable "sg_control_plane_tags" {
  description = "Map of tags to apply to the security group for eks master."
  default     = {}
}

variable "sg_workers_tags" {
  description = "Map of tags to apply to the security group for eks workers."
  default     = {}
}

variable "tags" {
  description = "Map of tags to apply to all resources of the module (where applicable)."
  default     = {}
}

variable "eks_master_iam_role_name" {
  description = "Name of the iam role associated with eks master"
  type        = "string"
}

variable "eks_worker_iam_role_name" {
  description = "Name of the iam role associated with eks workers"
  type        = "string"
}

variable "eks_ingress_policy" {
  description = "Name of the policy that allows ingress to interact with aws resources"
  type        = "string"
}

variable "aws_vpc" {
  description = "Name of the vpc where the eks cluster is created"
  type        = "string"
}

variable "aws_subnet_ids" {
  description = "IDs of the subnet where EKS should be available"
  default     = []
}

variable "aws_vpc_cidr_block" {
  description = "cidr block of the vpc where the eks cluster is created"
  type        = "string"
}

variable "security_group_ids" {
  description = "Additional list of security group IDs for the eks cluster"
  default     = []
}

variable "eks_ami" {
  description = "Name of the ami to use for eks worker nodes"
  default     = "amazon-eks-node-1.13*"
}

variable "worker_node_public_address" {
  description = "Boolean that indicates if eks worker nodes should have a public ip or not"
  default     = false
}

variable "worker_ami" {
  description = "Customized ami for eks worker nodes"
  default     = ""
}

variable "worker_instance_type" {
  description = "Type of ec2 instance to use for worker nodes"
  type        = "string"
}

variable "worker_name_prefix" {
  description = "Prefix that wiil be used in the ec2 instance name for worker nodes"
  type        = "string"
}

variable "eks_node_userdata" {
  description = "Customized script to launch on the woker nodes at first startup to join the cluster"
  default     = ""
}

variable "worker_asg_desired_capacity" {
  description = "Number of worker nodes at startup"
  default     = "2"
}

variable "worker_asg_max_size" {
  description = "Maximum number of worker nodes"
  default     = "3"
}

variable "worker_asg_min_size" {
  description = "Minimum number of worker nodes"
  default     = "1"
}

variable "worker_asg_name" {
  description = "Name of the autoscalinggroup for worker nodes"
  type        = "string"
}

variable "worker_asg_tags" {
  description = "Map of tags to dynamically add to autoscaling group"
  default     = {}
}

variable "efs_name" {
  description = "Name of the security group associated with efs"
  type        = "string"
}

variable "efs_security_group_name" {
  description = "Name of the security group associated with efs"
  type        = "string"
}

variable "efs_file_system_tags" {
  description = "Map of tags to apply to the efs file system"
  default     = {}
}

variable "master_role_tags" {
  description = "Map of tags to apply to the IAM role for master"
  default     = {}
}

variable "worker_role_tags" {
  description = "Map of tags to apply to the IAM role for workers"
  default     = {}
}
