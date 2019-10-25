# terraform-module-aws-eks

Terraform module to deploy EKS cluster on AWS.
Optionally it can deploy ALB ingress controller.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_security\_group\_ids | List of security group ID's that will be allowed to talk to the EKS cluster. | list(string) | `[]` | no |
| eks\_tags | Map of tags that will be applied on the EKS cluster. | map | `{}` | no |
| enabled | Whether or not to enable this module. | string | `"true"` | no |
| iam\_role\_name | Name of the IAM role for the EKS cluster. | string | `"eks-cluster"` | no |
| iam\_role\_tags | Map of tags that will be applied on the IAM role. | map | `{}` | no |
| name | Name of the EKS cluster. | string | `"eks-cluster"` | no |
| private\_access | Whether or not to enable private access to the EKS endpoint. | string | `"true"` | no |
| public\_access | Whether or not to enable public access to the EKS endpoint. | string | `"true"` | no |
| security\_group\_ids | List of additionnal security group ID's to set on the AKS cluster. | list | `[]` | no |
| security\_group\_name | Name of the security group for the EKS cluster. | string | `"eks-cluster"` | no |
| security\_group\_tags | Map of tags that will be applied on the security group. | map | `{}` | no |
| subnet\_ids | List of subnet ID's where the EKS master will be available from. | list(string) | n/a | yes |
| tags | Map of tags that will be applied on all resources. | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the EKS cluster that is created. |
| certificate\_authority | Base 64 encoded certificate authority of the EKS cluster that is created. |
| endpoint | Endpoint of the EKS cluster that is created. |
| iam\_role\_arn | ARN of the IAM role that is created. |
| iam\_role\_id | ID of the IAM role that is created. |
| iam\_role\_name | Name of the IAM role that is created. |
| iam\_role\_unique\_id | Uniauq ID of the IAM role that is created. |
| id | ID of the EKS cluster that is created. |
| name | Name of the EKS cluster that is created. |
| security\_group\_arn | ARN of the security group that is created. |
| security\_group\_id | ID of the security group that is created. |
| security\_group\_name | Name of the security group that is created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
