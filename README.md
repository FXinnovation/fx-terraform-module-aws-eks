# terraform-module-aws-eks

Terraform module to deploy EKS cluster on AWS.
Optionally it can deploy ALB ingress controller.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb\_enabled | Boolean that indicates if alb ingress controller should be deployed in the cluster | string | `"false"` | no |
| aws\_subnet\_ids | IDs of the subnet where EKS should be available | list | `[]` | no |
| aws\_vpc | Name of the vpc where the eks cluster is created | string | n/a | yes |
| aws\_vpc\_cidr\_block | cidr block of the vpc where the eks cluster is created | string | n/a | yes |
| cluster\_name | Name of the EKS cluster | string | n/a | yes |
| efs\_file\_system\_tags | Map of tags to apply to the efs file system | map | `{}` | no |
| efs\_name | Name of the efs provided for persistent volumes | string | n/a | yes |
| efs\_security\_group\_name | Name of the security group associated with efs | string | n/a | yes |
| eks\_ami | Name of the ami to use for eks worker nodes | string | `"amazon-eks-node-1.13*"` | no |
| ingress\_policy\_name | Name of the policy that allows ingress to interact with aws resources | string | n/a | yes |
| master\_iam\_role\_name | Name of the iam role associated with eks master | string | n/a | yes |
| master\_role\_tags | Map of tags to apply to the IAM role for master | map | `{}` | no |
| master\_security\_group\_name | Name of the eks master security group. | string | `"aws-sg-eks-master"` | no |
| master\_security\_group\_tags | Map of tags to apply to the security group for eks master. | map | `{}` | no |
| security\_group\_ids | Additional list of security group IDs for the eks cluster | list | `[]` | no |
| tags | Map of tags to apply to all resources of the module \(where applicable\). | map | `{}` | no |
| worker\_ami | Customized ami for eks worker nodes | string | `""` | no |
| worker\_autoscalinggroup\_desired\_capacity | Number of worker nodes at startup | string | `"2"` | no |
| worker\_autoscalinggroup\_max\_size | Maximum number of worker nodes | string | `"5"` | no |
| worker\_autoscalinggroup\_min\_size | Minimum number of worker nodes | string | `"2"` | no |
| worker\_autoscalinggroup\_name | Name of the autoscalinggroup for worker nodes | string | n/a | yes |
| worker\_autoscalinggroup\_tags | Maps of tags to dynamically add to autoscaling group | list | `[]` | no |
| worker\_iam\_instance\_profile | Name of the instance profile for worker nodes | string | n/a | yes |
| worker\_iam\_role\_name | Name of the iam role associated with eks workers | string | n/a | yes |
| worker\_instance\_type | Type of ec2 instance to use for worker nodes | string | n/a | yes |
| worker\_name\_prefix | Prefix that wiil be used in the ec2 instance name for worker nodes | string | n/a | yes |
| worker\_node\_public\_address | Boolean that indicates if eks worker nodes should have a public ip or not | string | `"false"` | no |
| worker\_role\_tags | Map of tags to apply to the IAM role for workers | map | `{}` | no |
| worker\_security\_group\_name | Name of the eks nodes security group. | string | `"aws-sg-eks-nodes"` | no |
| worker\_security\_group\_tags | Map of tags to apply to the security group for eks workers. | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name |  |
| cluster\_public\_certificate |  |
| efs\_id |  |
| eks\_cluster\_endpoint |  |
| master\_role\_id |  |
| master\_sg\_id |  |
| worker\_asg\_id |  |
| worker\_role\_id |  |
| worker\_sg\_id |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
