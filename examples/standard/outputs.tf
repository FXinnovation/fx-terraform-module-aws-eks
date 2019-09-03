output "master-sg" {
  value = module.standard.master-sg
}

output "worker-sg" {
  value = module.standard.worker-sg
}

output "master-role" {
  value = module.standard.master-role
}

output "worker-role" {
  value = module.standard.master-role
}

output "cluster" {
  value = module.standard.cluster
}

output "worker-ami" {
  value = module.standard.worker-ami
}

output "asg" {
  value = module.standard.asg
}

output "endpoint" {
  value = module.standard.endpoint
}

output "eks_kubeconfig" {
  value = module.standard.eks_kubeconfig
}
