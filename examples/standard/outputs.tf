output "master_sg_id" {
  value = module.standard.master_sg_id
}

output "worker_sg_id" {
  value = module.standard.worker_sg_id
}

output "master_role_id" {
  value = module.standard.master_role_id
}

output "worker_role_id" {
  value = module.standard.worker_role_id
}

output "cluster_name" {
  value = module.standard.cluster_name
}

output "worker_asg_id" {
  value = module.standard.worker_asg_id
}

output "eks_cluster_endpoint" {
  value = module.standard.eks_cluster_endpoint
}

output "cluster_public_certificate" {
  value = module.standard.cluster_public_certificate
}
