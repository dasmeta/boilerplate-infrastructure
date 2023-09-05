terraform {
  cloud {
    organization = "boilerplate-testing"
    workspaces { name = "boilerplate-infrastructure" }
  }
}

variable "tfc_org" {}
variable "tfc_workspace" {}
variable "tfc_token" {}
variable "git_provider" {}
variable "git_org" {}
variable "git_repo" {}
variable "git_token" {}
variable "default_region" {}
variable "access_key_id" {}
variable "secret_access_key" {}

module "metacloud" {
  source  = "dasmeta/cloud/tfe"
  version = "v2.0.2"

  org   = var.tfc_org
  token = var.tfc_token

  rootdir   = "${path.module}/_terraform/"
  targetdir = "${path.module}/_terraform"
  yamldir   = "${path.module}/."

  git_provider = var.git_provider
  git_org      = var.git_org
  git_repo     = var.git_repo
  git_token    = var.git_token

  aws = {
    access_key_id     = var.access_key_id
    secret_access_key = var.secret_access_key
    default_region    = var.default_region
  }
}
