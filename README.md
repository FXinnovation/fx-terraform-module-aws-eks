# terraform-module-aws-eks

Terraform module to deploy EKS cluster on AWS.
Optionally it can deploy ALB ingress controller.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_security\_group\_ids | List of security group ID's that will be allowed to talk to the EKS cluster. | list(string) | n/a | yes |
| eks\_tags | Map of tags that will be applied on the EKS cluster. | map | `{}` | no |
| enabled | Whether or not to enable this module. | string | `"true"` | no |
| iam\_role\_name | Name of the IAM role for the EKS cluster. | string | `"eks-cluster"` | no |
| iam\_role\_tags | Map of tags that will be applied on the IAM role. | map | `{}` | no |
| name | Name of the EKS cluster. | string | `"eks-cluster"` | no |
| private\_access | Whether or not to enable private access to the EKS enpoint. | string | `"true"` | no |
| public\_access | Whether or not to enable public access to the EKS enpoint. | string | `"true"` | no |
| security\_group\_ids | List of additionnal security group ID's to set on the AKS cluster. | list | `[]` | no |
| security\_group\_name | Name of the security group for the EKS cluster. | string | `"eks-cluster"` | no |
| security\_group\_tags | Map of tags that will be applied on the security group. | map | `{}` | no |
| subnet\_ids | List of subnet ID's where the EKS master will be available from. | list(string) | n/a | yes |
| tags | Map of tags that will be applied on all resources. | map | `{}` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
