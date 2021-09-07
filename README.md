# terraform-module-aws-eks

Terraform module to deploy EKS cluster on AWS.
Optionally it can deploy ALB ingress controller.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.master_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.master_missing_policy_from_aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.master_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this_allowed_egress_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_allowed_egress_cidrs_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_allowed_egress_cidrs_highports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_allowed_egress_highports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_allowed_egress_worker_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_allowed_egress_worker_highports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_ingress_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_ingress_443_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_ingress_443_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_egress_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_ingress_controlplane_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_ingress_controlplane_highports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_ingress_self_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [kubernetes_config_map.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [aws_iam_policy_document.allow_ec2_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDRs that will be allowed to talk to the EKS cluster. | `list(string)` | `[]` | no |
| <a name="input_allowed_security_group_count"></a> [allowed\_security\_group\_count](#input\_allowed\_security\_group\_count) | exact length of the `allowed_security_group_ids` variable. | `number` | `0` | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | List of security group ID's that will be allowed to talk to the EKS cluster. | `list(string)` | `[]` | no |
| <a name="input_aws_auth_configmap_data"></a> [aws\_auth\_configmap\_data](#input\_aws\_auth\_configmap\_data) | List of maps that represent the aws-auth data needed for EKS to work properly. https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html for more information. | `list` | `[]` | no |
| <a name="input_eks_tags"></a> [eks\_tags](#input\_eks\_tags) | Map of tags that will be applied on the EKS cluster. | `map` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether or not to enable this module. | `bool` | `true` | no |
| <a name="input_iam_policy_name"></a> [iam\_policy\_name](#input\_iam\_policy\_name) | Name of the additionnal IAM policy for the EKS cluster. | `string` | `"eks-cluster"` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name of the IAM role for the EKS cluster. | `string` | `"eks-cluster"` | no |
| <a name="input_iam_role_tags"></a> [iam\_role\_tags](#input\_iam\_role\_tags) | Map of tags that will be applied on the IAM role. | `map` | `{}` | no |
| <a name="input_kubernetes_aws_iam_integration_enabled"></a> [kubernetes\_aws\_iam\_integration\_enabled](#input\_kubernetes\_aws\_iam\_integration\_enabled) | Whether or not to enable the IAM Integration in kubernetes (this will allow you to map AWS IAM roles to specific Kubernetes service acounts) | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version that will be used for the EKS cluster. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EKS cluster. | `string` | `"eks-cluster"` | no |
| <a name="input_private_access"></a> [private\_access](#input\_private\_access) | Whether or not to enable private access to the EKS endpoint. | `bool` | `false` | no |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Whether or not to enable public access to the EKS endpoint. | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of additionnal security group ID's to set on the AKS cluster. | `list` | `[]` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of the security group for the EKS cluster. | `string` | `"eks-cluster"` | no |
| <a name="input_security_group_tags"></a> [security\_group\_tags](#input\_security\_group\_tags) | Map of tags that will be applied on the security group. | `map` | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet ID's where the EKS master will be available from. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags that will be applied on all resources. | `map` | `{}` | no |
| <a name="input_worker_security_group_name"></a> [worker\_security\_group\_name](#input\_worker\_security\_group\_name) | Name of the security group for the EKS cluster. | `string` | `"eks-workers-cluster"` | no |
| <a name="input_worker_security_group_tags"></a> [worker\_security\_group\_tags](#input\_worker\_security\_group\_tags) | Map of tags that will be applied on the security group. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the EKS cluster that is created. |
| <a name="output_certificate_authority"></a> [certificate\_authority](#output\_certificate\_authority) | Base 64 encoded certificate authority of the EKS cluster that is created. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint of the EKS cluster that is created. |
| <a name="output_iam_openid_connect_provider_arn"></a> [iam\_openid\_connect\_provider\_arn](#output\_iam\_openid\_connect\_provider\_arn) | n/a |
| <a name="output_iam_openid_connect_provider_url"></a> [iam\_openid\_connect\_provider\_url](#output\_iam\_openid\_connect\_provider\_url) | n/a |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role that is created. |
| <a name="output_iam_role_id"></a> [iam\_role\_id](#output\_iam\_role\_id) | ID of the IAM role that is created. |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the IAM role that is created. |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Uniauq ID of the IAM role that is created. |
| <a name="output_id"></a> [id](#output\_id) | ID of the EKS cluster that is created. |
| <a name="output_kubernates_config_map_name"></a> [kubernates\_config\_map\_name](#output\_kubernates\_config\_map\_name) | Config map for EKS workers |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | Version of the EKS cluster. |
| <a name="output_name"></a> [name](#output\_name) | Name of the EKS cluster that is created. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group that is created. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group that is created. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the security group that is created. |
| <a name="output_worker_security_group_arn"></a> [worker\_security\_group\_arn](#output\_worker\_security\_group\_arn) | ARN of the security group that is created for the workers. |
| <a name="output_worker_security_group_id"></a> [worker\_security\_group\_id](#output\_worker\_security\_group\_id) | ID of the security group that is created for the workers |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
