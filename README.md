# teeraform-module-aws-eks

Terraform module to deploy an eks cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_subnet\_ids | IDs of the subnet where EKS should be available | list | `[]` | no |
| aws\_vpc | Name of the vpc where the eks cluster is created | string | n/a | yes |
| aws\_vpc\_cidr\_block | cidr block of the vpc where the eks cluster is created | string | n/a | yes |
| cluster\_name | Name of the EKS cluster | string | n/a | yes |
| efs\_file\_system\_tags | Map of tags to apply to the efs file system | map | `{}` | no |
| efs\_name | Name of the security group associated with efs | string | n/a | yes |
| efs\_security\_group\_name | Name of the security group associated with efs | string | n/a | yes |
| eks\_ami | Name of the ami to use for eks worker nodes | string | `"amazon-eks-node-1.13*"` | no |
| eks\_ingress\_policy | Name of the policy that allows ingress to interact with aws resources | string | n/a | yes |
| eks\_master\_iam\_role\_name | Name of the iam role associated with eks master | string | n/a | yes |
| eks\_node\_userdata | Customized script to launch on the woker nodes at first startup to join the cluster | string | `""` | no |
| eks\_worker\_iam\_role\_name | Name of the iam role associated with eks workers | string | n/a | yes |
| master\_role\_tags | Map of tags to apply to the IAM role for master | map | `{}` | no |
| master\_security\_group\_name | Name of the eks master security group. | string | `"aws-sg-eks-master"` | no |
| node\_security\_group\_name | Name of the eks nodes security group. | string | `"aws-sg-eks-nodes"` | no |
| security\_group\_ids | Additional list of security group IDs for the eks cluster | list | `[]` | no |
| sg\_control\_plane\_tags | Map of tags to apply to the security group for eks master. | map | `{}` | no |
| sg\_workers\_tags | Map of tags to apply to the security group for eks workers. | map | `{}` | no |
| tags | Map of tags to apply to all resources of the module \(where applicable\). | map | `{}` | no |
| worker\_ami | Customized ami for eks worker nodes | string | `""` | no |
| worker\_asg\_desired\_capacity | Number of worker nodes at startup | string | `"2"` | no |
| worker\_asg\_max\_size | Maximum number of worker nodes | string | `"3"` | no |
| worker\_asg\_min\_size | Minimum number of worker nodes | string | `"1"` | no |
| worker\_asg\_name | Name of the autoscalinggroup for worker nodes | string | n/a | yes |
| worker\_asg\_tags | Maps of tags to dynamically add to autoscaling group | list | `[]` | no |
| worker\_instance\_type | Type of ec2 instance to use for worker nodes | string | n/a | yes |
| worker\_name\_prefix | Prefix that wiil be used in the ec2 instance name for worker nodes | string | n/a | yes |
| worker\_node\_public\_address | Boolean that indicates if eks worker nodes should have a public ip or not | string | `"false"` | no |
| worker\_role\_tags | Map of tags to apply to the IAM role for workers | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate |  |
| cluster |  |
| eks-cluster-endpoint |  |
| master-role-id |  |
| master-sg-id |  |
| worker-asg-id |  |
| worker-role-id |  |
| worker-sg-id |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
