output "name" {
  value = module.standard.name
}

output "id" {
  value = module.standard.id
}

output "arn" {
  value = module.standard.arn
}

output "certificate_authority" {
  value     = module.standard.certificate_authority
  sensitive = true
}

output "endpoint" {
  value     = module.standard.endpoint
  sensitive = true
}

output "iam_role_name" {
  value = module.standard.iam_role_name
}

output "iam_role_id" {
  value = module.standard.iam_role_id
}

output "iam_role_arn" {
  value = module.standard.iam_role_arn
}

output "iam_role_unique_id" {
  value = module.standard.iam_role_unique_id
}

output "security_group_name" {
  value = module.standard.security_group_name
}

output "security_group_id" {
  value = module.standard.security_group_id
}

output "security_group_arn" {
  value = module.standard.security_group_arn
}

output "worker_security_group_id" {
  value = module.standard.worker_security_group_id
}

output "worker_security_group_arn" {
  value = module.standard.worker_security_group_arn
}

output "kubernetes_version" {
  value = module.standard.kubernetes_version
}

output "kubernates_config_map_name" {
  value = module.standard.kubernates_config_map_name
}

output "iam_openid_connect_provider_arn" {
  value = module.standard.iam_openid_connect_provider_arn
}

output "iam_openid_connect_provider_url" {
  value = module.standard.iam_openid_connect_provider_url
}
