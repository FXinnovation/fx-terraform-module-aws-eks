provider "aws" {
  version    = "~> 2.27.0"
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

provider "random" {
  version = "~> 2.0"
}
