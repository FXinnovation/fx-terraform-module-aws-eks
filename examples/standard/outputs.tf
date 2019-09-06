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

output "cluster" {
  value = module.standard.cluster
}

output "worker-asg-id" {
  value = module.standard.worker-asg-id
}

output "eks-cluster-endpoint" {
  value = module.standard.eks-cluster-endpoint
}

output "certificate" {
  value = module.standard.certificate
}
