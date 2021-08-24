terraform {
  required_version = ">= 0.14"

  required_providers {
    aws        = ">= 3.5"
    kubernetes = ">= 2.4"
    random     = ">= 3.1"
  }
}
