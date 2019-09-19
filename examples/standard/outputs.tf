output "master_security_group_id" {
  value = module.standard.master_security_group_id
}

output "master_role_id" {
  value = module.standard.master_role_id
}

output "worker_security_group_id" {
  value = module.standard.worker_security_group_id
}

output "worker_role_id" {
  value = module.standard.worker_role_id
}

output "worker_autoscaling_group_id" {
  value = module.standard.worker_autoscaling_group_id
}

output "cluster_name" {
  value = module.standard.cluster_name
}

output "cluster_endpoint" {
  value = module.standard.cluster_endpoint
}

output "cluster_public_certificate" {
  value     = module.standard.cluster_public_certificate
  sensitive = true
}
