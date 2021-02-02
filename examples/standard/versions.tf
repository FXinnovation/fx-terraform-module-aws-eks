terraform {
  required_version = ">= 0.12"

  required_providers {
    aws        = "~> 2.31"
    kubernetes = "1.9"
    random     = "~> 2.0"
  }
}
