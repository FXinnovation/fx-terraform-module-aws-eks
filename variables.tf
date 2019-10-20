variable "name" {
  description = "Name of the EKS cluster"
  type        = "string"
}

variable "master_security_group_name" {
  description = "Name of the eks master security group."
  default     = "aws-sg-eks-master"
}

variable "master_role_tags" {
  description = "Map of tags to apply to the IAM role for master"
  default     = {}
}

variable "master_security_group_tags" {
  description = "Map of tags to apply to the security group for eks master."
  default     = {}
}

variable "master_iam_role_name" {
  description = "Name of the iam role associated with eks master"
  type        = "string"
}

variable "master_private_access" {
  description = "Boolean that indicates if the apiserver should have a private access"
  default     = true
}

variable "master_public_access" {
  description = "Boolean that indicates if the apiserver should have a public access"
  default     = true
}

variable "worker_security_group_name" {
  description = "Name of the eks nodes security group."
  default     = "aws-sg-eks-nodes"
}

variable "worker_security_group_tags" {
  description = "Map of tags to apply to the security group for eks workers."
  default     = {}
}

variable "worker_iam_role_name" {
  description = "Name of the iam role associated with eks workers"
  type        = "string"
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

variable "worker_autoscaling_group_desired_capacity" {
  description = "Number of worker nodes at startup"
  default     = "2"
}

variable "worker_autoscaling_group_max_size" {
  description = "Maximum number of worker nodes"
  default     = "5"
}

variable "worker_autoscaling_group_min_size" {
  description = "Minimum number of worker nodes"
  default     = "2"
}

variable "worker_autoscaling_group_name" {
  description = "Name of the autoscalinggroup for worker nodes"
  type        = "string"
}

variable "worker_autoscaling_group_tags" {
  description = "Maps of tags to dynamically add to autoscaling group"
  default     = []
}

variable "worker_role_tags" {
  description = "Map of tags to apply to the IAM role for workers"
  default     = {}
}

variable "worker_iam_instance_profile" {
  description = "Name of the instance profile for worker nodes"
  type        = "string"
}

variable "worker_use_max_pods" {
  description = "Boolean that indicates if a limit of authorized pods is set or not"
  default     = true
}

variable "tags" {
  description = "Map of tags to apply to all resources of the module (where applicable)."
  default     = {}
}

variable "vpc_id" {
  description = "Name of the vpc where the eks cluster is created"
  type        = "string"
}

variable "subnet_ids" {
  description = "IDs of the subnet where EKS should be available"
  default     = []
}

variable "security_group_ids" {
  description = "Additional list of security group IDs for the eks cluster"
  default     = []
}

variable "ami_name" {
  description = "Name of the ami to use for eks worker nodes"
  default     = "amazon-eks-node-1.13*"
}
