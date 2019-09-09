output "master-sg-id" {
  value = module.standard.master-sg-id
}

output "worker-sg-id" {
  value = module.standard.worker-sg-id
}

output "master-role-id" {
  value = module.standard.master-role-id
}

output "worker-role-id" {
  value = module.standard.worker-role-id
}

output "cluster-name" {
  value = module.standard.cluster-name
}

output "worker-asg-id" {
  value = module.standard.worker-asg-id
}

output "eks-cluster-endpoint" {
  value = module.standard.eks-cluster-endpoint
}

output "cluster-public-certificate" {
  value = module.standard.cluster-public-certificate
}
