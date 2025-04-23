terraform {
    cloud {
        organization = "Demo-Dasmeta"
        workspaces { name = "infrastructure" }
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
variable "region" {}
variable "access_key_id" {}
variable "secret_access_key" {}
variable "session_token" {}
variable "security_token" {}

module "metacloud" {
  source  = "dasmeta/cloud/tfe"
  version = "2.5.1"

  org   = var.tfc_org
  token = var.tfc_token

  rootdir   = "${path.module}/_terraform/" # should be default value
  targetdir = "${path.module}/_terraform" # should be default value
  yamldir   = "${path.module}/."

  git_provider = var.git_provider
  git_org      = var.git_org
  git_repo     = var.git_repo
  git_token    = var.git_token

  auto_apply   = true

  aws = {
    access_key_id     = var.access_key_id
    secret_access_key = var.secret_access_key
    session_token     = var.session_token
    security_token    = var.security_token
    region            = var.region
    default_region    = var.default_region
  }
}