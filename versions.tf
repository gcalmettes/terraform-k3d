terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.11"
    }
    helm = {
        source  = "hashicorp/helm"
        version = "~> 2.1.0"
      }
  }
  required_version = ">= 0.14"
}

