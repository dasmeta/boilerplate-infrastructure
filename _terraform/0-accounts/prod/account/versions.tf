## This file and its content are generated based on config, pleas check README.md for more details

terraform {
  cloud {
    organization = "Demo-Dasmeta"

    workspaces {
      name = "0-accounts_prod_account"
    }
  }
  
  required_providers {
  
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [aws.virginia]
    }
  
  }

  required_version = ">= 1.3.0"
}
