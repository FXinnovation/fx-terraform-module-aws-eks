provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "kubernetes" {
  host                   = module.standard.endpoint
  cluster_ca_certificate = base64decode(module.standard.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

provider "random" {
}
