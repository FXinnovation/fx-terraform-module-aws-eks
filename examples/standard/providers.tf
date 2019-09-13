provider "aws" {
  version    = "~> 2.27.0"
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

provider "kubernetes" {
  host                   = module.standard.cluster_endpoint
  cluster_ca_certificate = base64decode(module.standard.cluster_public_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.1.2"
}
