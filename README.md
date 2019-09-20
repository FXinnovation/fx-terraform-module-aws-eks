# terraform-module-aws-eks

Terraform module to deploy EKS cluster on AWS.
Optionally it can deploy ALB ingress controller.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb\_enabled | Boolean that indicates if alb ingress controller should be deployed in the cluster | string | `"false"` | no |
| alb\_image\_version | Version of the docker image used to deploy alb ingress controller | string | n/a | yes |
| ami\_name | Name of the ami to use for eks worker nodes | string | `"amazon-eks-node-1.13*"` | no |
| efs\_dns\_name | DNS name of the efs to create persistent volumes | string | n/a | yes |
| efs\_id | ID of the efs to create persistent volumes | string | n/a | yes |
| ingress\_policy\_name | Name of the policy that allows ingress to interact with aws resources | string | n/a | yes |
| master\_iam\_role\_name | Name of the iam role associated with eks master | string | n/a | yes |
| master\_private\_access | Boolean that indicates if the apiserver should have a private access | string | `"true"` | no |
| master\_public\_access | Boolean that indicates if the apiserver should have a public access | string | `"true"` | no |
| master\_role\_tags | Map of tags to apply to the IAM role for master | map | `{}` | no |
| master\_security\_group\_name | Name of the eks master security group. | string | `"aws-sg-eks-master"` | no |
| master\_security\_group\_tags | Map of tags to apply to the security group for eks master. | map | `{}` | no |
| name | Name of the EKS cluster | string | n/a | yes |
| namespace | Name of the namespace who need to use efs | string | `"default"` | no |
| region | Aws region for deploying the module | string | n/a | yes |
| security\_group\_ids | Additional list of security group IDs for the eks cluster | list | `[]` | no |
| subnet\_ids | IDs of the subnet where EKS should be available | list | `[]` | no |
| tags | Map of tags to apply to all resources of the module (where applicable). | map | `{}` | no |
| vpc\_cidr\_block | cidr block of the vpc where the eks cluster is created | string | n/a | yes |
| vpc\_id | Name of the vpc where the eks cluster is created | string | n/a | yes |
| worker\_ami | Customized ami for eks worker nodes | string | `""` | no |
| worker\_autoscaling\_group\_desired\_capacity | Number of worker nodes at startup | string | `"2"` | no |
| worker\_autoscaling\_group\_max\_size | Maximum number of worker nodes | string | `"5"` | no |
| worker\_autoscaling\_group\_min\_size | Minimum number of worker nodes | string | `"2"` | no |
| worker\_autoscaling\_group\_name | Name of the autoscalinggroup for worker nodes | string | n/a | yes |
| worker\_autoscaling\_group\_tags | Maps of tags to dynamically add to autoscaling group | list | `[]` | no |
| worker\_iam\_instance\_profile | Name of the instance profile for worker nodes | string | n/a | yes |
| worker\_iam\_role\_name | Name of the iam role associated with eks workers | string | n/a | yes |
| worker\_instance\_type | Type of ec2 instance to use for worker nodes | string | n/a | yes |
| worker\_name\_prefix | Prefix that wiil be used in the ec2 instance name for worker nodes | string | n/a | yes |
| worker\_node\_public\_address | Boolean that indicates if eks worker nodes should have a public ip or not | string | `"false"` | no |
| worker\_role\_tags | Map of tags to apply to the IAM role for workers | map | `{}` | no |
| worker\_security\_group\_name | Name of the eks nodes security group. | string | `"aws-sg-eks-nodes"` | no |
| worker\_security\_group\_tags | Map of tags to apply to the security group for eks workers. | map | `{}` | no |
| worker\_use\_max\_pods | Boolean that indicates if a limit of authorized pods is set or not | string | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint |  |
| cluster\_name |  |
| cluster\_public\_certificate |  |
| master\_role\_id |  |
| master\_security\_group\_id |  |
| worker\_autoscaling\_group\_id |  |
| worker\_role\_id |  |
| worker\_security\_group\_id |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
