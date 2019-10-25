output "name" {
  description = "Name of the EKS cluster that is created."
  value       = module.standard.name
}

output "id" {
  description = "ID of the EKS cluster that is created."
  value       = module.stadard.id
}

output "arn" {
  description = "ARN of the EKS cluster that is created."
  value       = module.stadard.arn
}

output "certificate_authority" {
  description = "Base 64 encoded certificate authority of the EKS cluster that is created."
  value       = module.stadard.certificate_authority
  sensitive   = true
}

output "endpoint" {
  description = "Endpoint of the EKS cluster that is created."
  value       = module.stadard.endpoint
  sensitive   = true
}

output "iam_role_name" {
  description = "Name of the IAM role that is created."
  value       = module.stadard.iam_role_name
}

output "iam_role_id" {
  description = "ID of the IAM role that is created."
  value       = module.stadard.iam_role_id
}

output "iam_role_arn" {
  description = "ARN of the IAM role that is created."
  value       = module.stadard.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Uniauq ID of the IAM role that is created."
  value       = module.stadard.iam_role_unique_id
}

output "security_group_name" {
  description = "Name of the security group that is created."
  value       = module.stadard.security_group_name
}

output "security_group_id" {
  description = "ID of the security group that is created."
  value       = module.stadard.security_group_id
}

output "security_group_arn" {
  description = "ARN of the security group that is created."
  value       = module.stadard.security_group_arn
}
