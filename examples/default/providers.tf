#####
# Providers
#####

provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key

  assume_role {
    role_arn     = "arn:aws:iam::700633540182:role/OrganizationAccountAccessRole"
    session_name = "FXTestSandbox"
  }
}

provider "kubernetes" {
  host                   = module.standard.endpoint
  cluster_ca_certificate = base64decode(module.standard.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "random" {}
