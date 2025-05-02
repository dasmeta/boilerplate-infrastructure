## This file and its content are generated based on config, pleas check README.md for more details

terraform {
  cloud {
    organization = "Demo-Dasmeta"

    workspaces {
      name = "1-environments_prod_ingress"
    }
  }
  
  required_providers {
  
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = []
    }
  
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
      configuration_aliases = []
    }
  
  }

  required_version = ">= 1.3.0"
}
